require 'thin'
require 'faye'
require 'rack'
require 'json'

module CodeSync
  class Server
    attr_accessor :assets,
                  :faye,
                  :root


    def initialize options={}
      @assets = options[:assets] || CodeSync::SprocketsAdapter.new(root:Dir.pwd())
      @root   = options[:root]

      Faye::WebSocket.load_adapter('thin')
      @faye   = Faye::RackAdapter.new(mount:"/faye",timeout:25)

      faye.add_extension(FayeMonitor.new)
    end

    def start port=9295
      assets = @assets.env
      faye   = @faye
      
      app = Rack::URLMap.new "/assets" => assets, "/" => faye, "/info" => ServerInfo.new(sprockets:assets)
      Rack::Server.start(app:app,:Port=>9295,:server=>'thin')
    end 

    class Middleware

    end

    class FayeMonitor
      def incoming(message,callback)
        callback.call(message)
      end
    end

    class ServerInfo
      attr_accessor :faye, :sprockets

      def initialize options={}
        @sprockets  = options[:sprockets]  
        @faye       = options[:faye]
      end

      def call(env)
        [200, {"Content-Type" => "application/json"}, JSON.generate(paths:sprockets.paths)]        
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