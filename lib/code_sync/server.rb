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
      assets = @assets.env
      faye   = @faye

      app = Rack::URLMap.new "/assets" => assets, "/" => faye, "/info" => ServerInfo.new(sprockets:assets, options: options, root: root)
      Rack::Server.start(app:app,:Port=>port,:server=>'thin')
    end

    class Middleware

    end

    class FayeMonitor
      def incoming(message,callback)
        if message['channel'] == "/meta/subscribe" and message['subscription']
          puts "== A CodeSync enabled browser has connected"
        end

        callback.call(message)
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
        [200, {"Content-Type" => "application/json"}, JSON.generate(codesync_version: CodeSync::Version,paths:sprockets.paths, root:@options[:root])]
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