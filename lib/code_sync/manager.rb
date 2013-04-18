require "code_sync/server"
require "code_sync/sprockets_adapter"
require "pry"

# In order to support the live-editing and immediate preview of
# of precompiled assets in the browser or in the developers IDE
# we need a background process that can integrate the file system
# watcher, sprockets compiler environment, and rack process server.
module CodeSync
  class Manager

    def self.start options={}
      manager = new(options)

      if options[:auto_start] == false
        return manager
      else
        manager.start
      end

      manager
    end

    attr_accessor :sprockets, :server, :client_manager, :options, :processes

    def start
      $0 = "codesync process: manager"

      @pids = processes.map do |config|
        fork do
          name, block = config

          $0 = "codesync process: #{ name }"
          block.call
        end
      end

      trap("SIGINT") do
        @pids.each {|p| Process.kill(9,p) }
      end

      Process.waitall do
        puts "Waitall"
      end

      puts "All child processes exited cleanly."
    end

    protected

      def initialize options={}
        @options = options.dup

        # we want to match the sprockets environment that would be
        # available to this rails, or middleman project.  this means
        # re-using the asset pipeline gems it has available, and having
        # the same source paths
        create_sprockets_environment()

        create_pubsub_server()

        #expose_via_rack(sprockets, pubsub)

        listen_for_changes_on_the_filesystem do |changed_assets|
          changed_assets.each do |asset|
            notify_clients_of_change_to(asset)
          end
        end

        listen_for_changes_from_clients do |changed_assets|
          changed_assets.each do |asset|
            record_changes_made_to(asset)
            notify_clients_of_change_to(asset)
          end
        end
      end

      def create_pubsub_server
        @server = CodeSync::Server.new(assets: sprockets, root: root)

        manage_child_process("server") do
          server.start()
        end
      end

      def create_sprockets_environment
        @sprockets = options[:sprockets] || SprocketsAdapter.new(root: root)
      end

      def notify_clients_of_change_to asset
        payload = JSON.generate(asset)
        EM.run do
          pub = client.publish("/code-sync", asset)
          pub.callback { EM.stop }
        end
      end

      def client
        @client = ::Faye::Client.new("http://localhost:9295/faye")
      end

      def listen_for_changes_on_the_filesystem &handler
        manage_child_process("watcher") do
          watcher.change do |modified,added,removed|
            handler.call process_changes_to(modified+added)
          end

          watcher.start
        end
      end

      def manage_child_process name, &block
        @processes ||= []
        @processes << [name,block]
      end

      def process_changes_to assets
        sprockets.process_changes_to(assets)
      end

      def root
        options[:root] || options[:assets_directory] || Dir.pwd()
      end

      def watcher
        @watcher ||= Listen.to(root)
                      .filter(assets_filter)
                      .latency(1)
      end

      # TODO
      # Provide for configurability
      def assets_filter
       /(\.coffee|\.css|\.jst|\.mustache)/
      end

      def method_missing meth, *args, &block
        puts "Need to implement #{ meth }"
      end
  end
end