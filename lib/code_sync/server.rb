require 'thin'
require 'faye'
require 'rack'
require 'json'
require 'pry'

require "code_sync/temp_asset"
require "code_sync/sprockets_adapter"

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

      def handle_file_write(params={}, response)
        path, contents = params.values_at "path", "contents"

        unless path.match(/^\//)
          path = File.join(root,path)
        end

        begin
          if File.exists?(path)
            File.open(path,"w+") {|fh| fh.puts(contents)}
          else
            response[:success] = false
            response[:error] = "File not found: #{ path } :: #{ $! }"
          end
        rescue
          response[:error] = "#{ $! }"
          response[:success] = false
        end
      end

      def handle_adhoc_compilation(params={}, response={})
        contents, filename, extension = params.values_at("contents", "name", "extension")

        begin
          asset = TempAsset.create_from(contents, env: sprockets, filename: filename, extension: extension)
          response[:contents] = contents
          response[:compiled] = process_compiled_asset(asset.to_s,filename,extension)
        rescue
          response[:error] = $!
          response[:success] = false
        end

        response
      end

      def process_compiled_asset contents, filename, extension
        begin
          processor = CodeSync.lookup_processor_for_extension(extension)
          processor.process(contents,filename,extension)
        rescue
          contents
        end
      end

      def handle_post(env)
        response = {success: true}

        env['rack.input'].rewind
        body = env['rack.input'].read

        params = begin
         JSON.parse(body)
        rescue
          response[:success] = false
          response[:error] = $!
          response[:body] = body
          return response
        end

        if params["path"] && params["contents"]
          handle_file_write(params, response)
        end

        if params["name"] && params["extension"] && params["contents"]
          handle_adhoc_compilation(params, response)
        end

        response
      end

      def handle_get(env)
        response = {success: true}

        query = Rack::Utils.parse_query env['QUERY_STRING']

        if query['path']
          response.merge! success: true, contents: IO.read(query["path"])
        else
          response.merge! success: false, error: "Must specify an asset path"
        end

        response
      end

      # Why am I not just using Sinatra here?
      def call(env)
        response = if env['REQUEST_METHOD'] == "POST"
          handle_post(env)
        else
          handle_get(env)
        end

        if response[:success]
          [200, {"Access-Control-Allow-Origin"=>"*","Content-Type" => "application/json"}, [JSON.generate(response)] ]
        else
          [200, {"Access-Control-Allow-Origin"=>"*","Content-Type" => "application/json"}, [JSON.generate(response)] ]
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