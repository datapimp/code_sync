module CodeSync
  class Publisher
    attr_reader :client, :url

    def initialize url 
      @url = url
    end

    def client
      @client ||= ::Faye::Client.new(url)
    end

    def shutdown
      EM.stop
    end

    def publish channel, message
      EM.run do
        client = ::Faye::Client.new(url)
        pub    = client.publish( channel, message )
        pub.callback { EM.stop }
        pub.errback { EM.stop }
      end
    end

  end
end