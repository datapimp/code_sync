module CodeSync
  module Server

    attr_reader :assets

    def initialize options={}
      @assets = CodeSync::SprocketsAdapter.new()
    end
  end  
end