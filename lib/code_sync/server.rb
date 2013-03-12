module CodeSync
  class Server < Faye::RackAdapter
    attr_accessor :assets

    def initialize options={}
      super
      @assets = CodeSync::SprocketsAdapter.new(root:Dir.pwd())
    end

    def start port=9295
      listen(port)
    end 
  end
end
