require 'sprockets'

module CodeSync
  class TempAsset < Sprockets::BundledAsset
    def self.create_from content, options={}
      environment, filename, extension = options.values_at(:env, :filename, :extension)

      filename    = filename || "compiled"

      tempfile        = Tempfile.new([filename, extension])

      tempfile.write(content) && tempfile.rewind

      pathname        = Pathname.new(tempfile.path)
      logical_path    = File.basename(pathname)

      new(environment, logical_path, pathname)
    end
  end
end