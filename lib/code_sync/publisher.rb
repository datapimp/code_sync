module CodeSync
  class Publisher
    attr_reader :client, :url

    def initialize options={}
      @url, @client = options.values_at(:url, :client)
    end

    def client
      @client = nil if @client && !@client.is_a?(::Faye::Client)
      @client ||= ::Faye::Client.new(url)
    end

    def shutdown
      EM.stop
    end

    def publish channel="/code-sync", message="{status:'ok'}"
      binding.pry
      puts "Publishing to #{ channel } #{ message.length }"
      EM.run do
        pub    = client.publish( channel, message )
        pub.callback { EM.stop }
        pub.errback { EM.stop }
      end
    end

  end
end