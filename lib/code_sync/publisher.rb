module CodeSync
  class Publisher
    attr_reader :client, :url

    def initialize options={}
      @url, @client = options.values_at(:url, :client)
    end

    def client
      @client = ::Faye::Client.new(url)
    end

    def shutdown
      EM.stop
    end

    def publish channel="/code-sync", message="{status:'ok'}"
      EM.run do
        pub = client.publish(channel,message)
        pub.callback do
          EM.stop
        end
        pub.errback { EM.stop }
      end
    end

  end
end