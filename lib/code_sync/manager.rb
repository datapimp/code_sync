require "code_sync/server"
require "code_sync/sprockets_adapter"
require "listen"
require "pty"

# In order to support the live-editing and immediate preview of
# of precompiled assets in the browser or in the developers IDE
# we need a background process that can integrate the file system
# watcher, sprockets compiler environment, and rack process server.
module CodeSync
  class Manager

    def self.start options={}
      begin
        manager = new(options)

        cleanup_stale_processes

        if options[:forked]
          pid = fork do
            manager.start
          end

          Process.detach(pid)
        else
          manager.start(options)
        end
      rescue
        puts "Error Manager. #{ $! }"
      ensure
        cleanup_stale_processes
      end
    end

    # FIXME:
    # You know this aint right
    def self.cleanup_stale_processes
      PTY.spawn("ps aux |grep 'codesyn[c]'") do |stdin,stdout,pid|
        stdin.each do |output|
          if pid = output.split[1]
            `kill -9 #{ pid }`
          end
        end
      end
    end

    attr_accessor :sprockets, :server, :client_manager, :options, :processes, :process_map

    def start options={}
      if already_running?
        puts "== Codesync is already running"
        return
      end

      $0 = "codesync process: manager"

      build_process_map

      trap("SIGINT") do
        exit_gracefully # :)
      end


      puts "== All CodeSync processes exited cleanly."
    end

    protected
      def build_process_map
        @process_map = processes.inject({}) do |memo,config|
          name = config.first

          memo[name] = pid = fork do
            name, block = config

            $0 = "codesync process: #{ name }"
            block.call
          end

          memo
        end

        Process.waitall
      end

      def already_running?
        test = `ps aux |grep "c[o]desync process: manager"`

        test.match(/manager/)
      end

      def exit_gracefully
        puts "EXIT"

        yield if block_given?

        puts "Didn't make it past yield"
        puts "#{ process_map.inspect }"

        process_map.each do |process_name,pid|
          Process.kill(9,pid)
        end
      end

      def initialize options={}
        @options = options.freeze


        create_server()

        unless options[:disable_watcher]
          listen_for_changes_on_the_filesystem do |changed_assets|
            changed_assets.each do |asset|
              notify_clients_of_change_to(asset)
            end
          end
        end

        if options[:enable_listener]
          listen_for_changes_from_clients do |changed_assets|
          end
        end

        if options[:enable_internal_watch]
          listen_for_changes_to_code_sync()
        end
      end

      def create_server
        @sprockets = SprocketsAdapter.new(root: root, sprockets: options[:sprockets])
        @server = CodeSync::Server.new(assets: sprockets, root: root, forbid_saving: !!(options[:forbid_saving]) )

        manage_child_process("server") do
          server.start()
        end
      end

      def notify_clients_of_change_to asset
        payload = JSON.generate(asset)

        puts "== Codesync detected change: #{ asset[:name] }"

        EM.run do
          pub = client.publish("/code-sync/outbound", asset)
          pub.callback { EM.stop }
        end
      end

      def client
        @client = ::Faye::Client.new("http://localhost:9295/faye")
      end

      def listen_for_changes_from_clients &handler
        manage_child_process("listener") do
          EM.run do
            client.subscribe("/code-sync/inbound") do |message|
              puts "Received Code-Sync Inbound"
              puts message.inspect
            end
          end
        end
      end

      def listen_for_changes_to_code_sync &handler
        manage_child_process("internal") do
          internal.respond_to?(:start!) ? internal.start! : internal.start
        end
      end

      def listen_for_changes_on_the_filesystem &handler
        manage_child_process("watcher") do
          watcher.change do |modified,added,removed|
            processed = process_changes_to(modified+added)
            handler.call(processed)
          end

          # the listen gem api changed
          if watcher.respond_to?(:start!)
            watcher.start!
          else
            watcher.start
          end
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
        base = options[:root] || options[:assets_directory] || Dir.pwd()
      end

      def internal
        lib = File.dirname(__FILE__)
        puts "Listening to #{ lib }"

        @internal_watch = Listen.to( lib )
          .filter(/.rb/)
          .latency(1)
          .change do
            restart_everything!
          end

        @internal_watch
      end

      def restart_everything!
      end

      def watcher
        if !@watcher
          puts "Codesync watch is looking for assets in: #{ root }"
        end

        @watcher ||= Listen.to(root)
                      .filter(assets_filter)
                      .latency(1)
      end

      # TODO
      # Provide for configurability
      def assets_filter
       /(\.coffee|\.css|\.jst|\.mustache\.js|\.sass)/
      end

      def method_missing meth, *args, &block
        puts "Need to implement #{ meth }"
      end
  end
end