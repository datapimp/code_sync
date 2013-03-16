module CodeSync
  class CommandRunner
    attr_accessor :client,
                  :assets

    def initialize options={}
      @client, @assets = options.values_at(:client, :assets)      
    end

    def start
      puts "Starting Command Runner"
      client = @client

      EM.run {
        puts "Subscribing to code-sync commands channel"
        client.subscribe("/code-sync/commands") do |command|
          puts "Received Code Sync Command"
          puts command.inspect
        end        
      }
    end
  end
end