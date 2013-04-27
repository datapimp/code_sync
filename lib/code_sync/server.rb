require 'thin'
require 'faye'
require 'rack'
require 'json'

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
      attr_accessor :sprockets

      def initialize options={}
        @sprockets = options[:sprockets]
      end

      def call(env)
        if env['REQUEST_METHOD'] == "POST"
          query = Rack::Utils.parse_query( env['rack.input'].read )

          if File.exists?(query["path"]) && query["contents"]
            File.open(query["path"],"w+") do |fh|
              fh.puts(query["contents"])
            end
          end

        else
          query = Rack::Utils.parse_query env['QUERY_STRING']
        end

        path = query["path"]

        if sprockets.project_assets.include?(path)
          [200, {"Access-Control-Allow-Origin"=>"*","Content-Type" => "application/json"}, JSON.generate(path: path, contents: IO.read(path)) ]
        else
          [404, {}, "{}"]
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

      def call(env)
        [200, {"Access-Control-Allow-Origin"=>"*","Content-Type" => "application/json"}, JSON.generate(project_assets: sprockets.project_assets, codesync_version: CodeSync::Version,paths:sprockets.env.paths, root:@options[:root])]
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