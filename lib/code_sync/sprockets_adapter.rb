require 'sprockets'

module CodeSync
  class SprocketsAdapter
    attr_accessor :env, :options

    def initialize sprockets, options=nil
      if options.nil? and sprockets.is_a?(Hash)
        options = sprockets
        sprockets = nil
      end

      @options = options

      @env = sprockets || Sprockets::Environment.new(options[:root] ||= Dir.pwd())

      append_asset_paths()
    end

    def compile content, options={}
      create_asset(content,options).to_s
    end

    def create_asset content, options={}
      TempAsset.create_from(content, options.merge(env: env)) 
    end

    def method_missing meth, *args, &block
      env.send(meth, *args, &block)
    end

    protected

      def tmpdir
        @tmpdir ||= Dir.tmpdir
      end

      def append_temporary_path
        env.prepend_path(tmpdir)
      end

      def append_asset_paths base_path=nil
        base_path ||= env.root

        env.append_path tmpdir

        %w{lib vendor app}.each do |base|
          path = File.join(env.root, base, 'assets')

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