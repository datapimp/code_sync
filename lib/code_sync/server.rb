require 'thin'
require 'faye'

module CodeSync
  class Server
    attr_accessor :assets

    def initialize options={}
      @assets = CodeSync::SprocketsAdapter.new(root:Dir.pwd())

      Faye::WebSocket.load_adapter('thin')
      @faye   = Faye::RackAdapter.new(mount:"/faye",timeout:25)
    end

    def start port=9295
      assets = @assets.env
      faye   = @faye


      Thin::Server.start('0.0.0.0', port) do
        map "/assets" do
          run assets
        end

        map "/" do 
          run faye
        end
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