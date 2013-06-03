module CodeSync
  class AssetPipelineGems
    TestPaths = %w{
      assets/stylesheets
      assets/javascripts
      assets/images
      app/assets/javascripts
      lib/assets/javascripts
      vendor/assets/javascripts
      app/assets/stylesheets
      lib/assets/stylesheets
      vendor/assets/stylesheets
      app/assets/images
      lib/assets/images
      vendor/assets/images
      javascripts
      stylesheets
      images
    }

    def self.gems
      begin
        return @gems if !@gems.nil?

        gems = ::Gem::Specification.latest_specs

        gems.select! do |gemspec|
          base = gemspec.full_gem_path
          TestPaths.detect {|folder| File.exists?(File.join(base,folder))}
        end
      rescue
        []
      end
    end

    def self.paths
      paths = gems.flat_map do |gemspec|
        base = gemspec.full_gem_path
        TestPaths.map {|folder| File.join(base, folder)}
      end

      paths.select {|dir| File.exists?(dir) }
    end
  end

  class SprocketsAdapter
    attr_accessor :env, :options

    def initialize sprockets, options=nil
      if options.nil? and sprockets.is_a?(Hash)
        options = sprockets
        sprockets = nil
      end

      @options = options

      @env = options[:sprockets] || Sprockets::Environment.new(options[:root] ||= Dir.pwd())

      append_asset_paths()
    end

    def process_changes_to assets=[]
      results = Array(assets).map do |path|
        asset = env.find_asset(path)

        if !asset
          asset = env.find_asset( path.split('/').pop )
        end

        if asset
          logical_name  = asset.logical_path
          basename      = File.basename(path)
          extension     = basename.split('.').slice(1,100).join(".")

          is_template = ['.jst.skim','.jst','.hamlc','.mustache'].any? do |needle|
            !basename[needle].nil?
          end

          codesync_document_attributes = {
            path: path,
            extension: "." + extension,
            name: basename,
            logical_name: logical_name,
            compiled: (asset.to_s rescue nil),
            content: IO.read(path),
            template: is_template
          }
        end

        codesync_document_attributes
      end

      Array(results.compact)
    end

    def compile content, options={}
      create_asset(content,options).to_s
    end

    def create_asset content, options={}
      TempAsset.create_from(content, options.merge(env: env))
    end

    def project_asset_directories
      directories = env.paths.select {|path| path.include?(root) }
    end

    def project_assets
      files = project_asset_directories.inject([]) do |memo, path|
        memo += Dir.glob("#{path}/**/*")
      end

      files.reject! {|path| path.match(/\.min\.js/) || path.match(/\-min\.js/) }
      files.select! {|path| path.match(/\.jst|\.mustache|\.skim|\.hamlc|\.scss|\.sass|\.coffee|\.css|\.js/)}

      files.map do |file|
        asset         = env.find_asset(file)
        logical_path  = asset && asset.logical_path
        folder        = if asset.content_type == "application/javascript"
          "javascripts"
        else
          "stylesheets"
        end

        {
          :path => file,
          :name => File.basename(file),
          :logical_path => logical_path,
          :url => "#{ folder }/#{ logical_path }",
          :relative_path => file.gsub(root,'.')
        }
      end
    end


    def method_missing meth, *args, &block
      env.send(meth, *args, &block)
    end

    protected

      def tmpdir
        @tmpdir ||= Dir.tmpdir
      end

      def append_gem_paths
        AssetPipelineGems.paths.each {|path| env.append_path(path) }
      end

      def append_temporary_path
        env.prepend_path(tmpdir)
      end

      def append_asset_paths base_path=nil
        base_path ||= env.root

        append_gem_paths

        env.append_path tmpdir

        env.append_path CodeSync.gem_assets_root

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