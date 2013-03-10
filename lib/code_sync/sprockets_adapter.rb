require 'sprockets'

module CodeSync
  class SprocketsAdapter
    attr_accessor :env, :options

    def initialize options={}
      @options = options

      options[:root] ||= Dir.pwd()
      @env = Sprockets::Environment.new(options[:root])

      append_asset_paths() if env.paths.length == 0

    end

    protected

      def append_asset_paths base_path=nil
        base_path ||= env.root

        %w{lib vendor app}.each do |base|
          path = File.join(env.root, base, 'assets' )

          if File.exists?(path)
            %w{images stylesheets javascripts}.each do |type|
              if File.exists?(File.join(path, type))
                env.append_path(File.join(path, type))
              end
            end
          end
        end        
      end
  end
end