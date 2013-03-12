module CodeSync
  class Watcher
    attr_reader :options,
                :listener,
                :notifier,
                :assets,
                :id

    def initialize(options={})
      @options  = options
      @notifier = Publisher.new(options[:url] || "//localhost:9295/faye")
      @assets   = SprocketsAdapter.new(root: Dir.pwd())
      @id       = rand(36**36).to_s(36).slice(0,8)

      @listener = Listen.to(assets_directory)
                    .filter(options[:filter] || /(\.coffee|\.css|\.jst|\.mustache)/)
                    .latency(options[:latency] || 1)
                    .change do |modified, added, removed|
                      notify(modified, added, removed)
                    end
    end

    def assets_directory
      @options[:assets_directory] || Dir.pwd()
    end

    def throttle?
      !@last_change_detected_at.nil? && seconds_since_last_change < 5
    end

    def seconds_since_last_change
      Time.now.to_i - (@last_change_detected_at || 0).to_i
    end

    def notify modified, added, removed
      return if throttle?
      @last_change_detected_at = Time.now.to_i 

      puts "Detected changes in #{ (modified + added).inspect }"
      begin 
        payload = change_payload_for(modified + added)
        puts payload.inspect
        notifier.publish("/code-sync", payload)
      rescue e
        puts "Error publishing payload: #{ $! }"
      end
    end

    def change_payload_for paths     
      paths.inject({}) do |memo, path| 
        if asset = assets.find_asset(path)
          memo[asset.logical_path] = {
            name:   asset.logical_path,
            path:   asset.digest_path,
            source: asset.to_s
          }
        end
      end
    end

    def start
      @listener.start
    end
  end


end
