require 'thin'
require 'faye'
require 'rack'
require 'json'
require "code_sync/temp_asset"

module CodeSync
  class Server
    attr_accessor :assets,
                  :faye,
                  :root,
                  :options


    def initialize options={}
      @options = options.dup
      @assets = options[:assets] || CodeSync::SprocketsAdapter.new(root:Dir.pwd())
      @root   = options[:root]

      Faye::WebSocket.load_adapter('thin')
      @faye   = Faye::RackAdapter.new(mount:"/faye",timeout:25)

      faye.add_extension(FayeMonitor.new)
    end

    def start port=9295
      app = Rack::URLMap.new  "/assets" => assets.env,
                              "/" => faye,
                              "/info" => ServerInfo.new(sprockets:assets, options: options, root: root),
                              "/source" => SourceProvider.new(sprockets:assets)

      Rack::Server.start(app:app,:Port=>port,:server=>'thin')
    end

    class FayeMonitor
      def incoming(message,callback)
        if message['channel'] == "/meta/subscribe" and message['subscription']
          puts "== A CodeSync enabled browser has connected"
        end

        callback.call(message)
      end
    end

    class SourceProvider
      attr_accessor :sprockets, :root

      def initialize options={}
        @sprockets = options[:sprockets]
        @root = options[:root] || Dir.pwd()
      end

      def to_s
        "codesync source gateway"
      end

      def call(env)
        response = {}

        if env['REQUEST_METHOD'] == "POST"

          env['rack.input'].rewind
          body = env['rack.input'].read

          query = begin
           JSON.parse(body)
          rescue
            puts "Error Parsing Query: #{ $! }"
            {}
          end

          if query["path"]

            begin
              if !query["path"].match(/^\//)
                query["path"] = root + '/' + query["path"]
              end

              if File.exists?(query["path"]) && query["contents"]
                File.open(query["path"],"w+") do |fh|
                  fh.puts(query["contents"])
                end
                response[:success] = true
              else
                response[:success] = false
                response[:error] = "No file found: #{ query['path;'] }"
              end
            rescue
              response[:success] = false
              response[:error] = $!
            end

          elsif (query["name"] && query["extension"] && query["contents"])
            begin
              asset = TempAsset.create_from(query["contents"], env: sprockets, filename: query["name"], extension: query["extension"] )

              response[:success] = true
              response[:contents] = query["contents"]
              response[:compiled] = asset.to_s
            rescue
              response[:success] = false
              response[:error] = $!
            end
          end

        else
          query = Rack::Utils.parse_query env['QUERY_STRING']

          if query['path']
            response.merge! success: true, contents: IO.read(query["path"])
          else
            response.merge! success: false, error: "Must specify an asset path"
          end
        end


        if response[:success]
          [200, {"Access-Control-Allow-Origin"=>"*","Content-Type" => "application/json"}, [JSON.generate(response)] ]
        else
          [406, {"Access-Control-Allow-Origin"=>"*","Content-Type" => "application/json"}, [JSON.generate(response)] ]
        end
      end
    end

    class ServerInfo
      attr_accessor :faye, :sprockets, :options

      def initialize options={}
        @sprockets  = options[:sprockets]
        @faye       = options[:faye]
        @options    = options.dup
      end

      def to_s
        "codesync server info"
      end

      def call(env)
        response = JSON.generate(project_assets: sprockets.project_assets, codesync_version: CodeSync::Version,paths:sprockets.env.paths, root:@options[:root])
        [200, {"Access-Control-Allow-Origin"=>"*","Content-Type" => "application/json"}, [response]]
      end
    end
  end
end

  #   Thin::Server.start('0.0.0.0', 3000) do
  #     use Rack::CommonLogger
  #     use Rack::ShowExceptions
  #     map "/lobster" do
  #       use Rack::Lint
  #       run Rack::Lobster.new
  #     end
  #   end