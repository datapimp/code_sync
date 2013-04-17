# In order to support the live-editing and immediate preview of
# of precompiled assets in the browser or in the developers IDE
# we need a background process that can integrate the file system
# watcher, sprockets compiler environment, and rack process server.
module CodeSync
  class Manager

    def self.start options={}
      new(options)
    end

    protected

      def initialize options={}
        # we want to watch for changes to asset pipeline assets
        # from within the project we're running the codesync command from
        create_project_root_file_watcher(root: options[:root])

        # we want to match the sprockets environment that would be
        # available to this rails, or middleman project.  this means
        # re-using the asset pipeline gems it has available, and having
        # the same source paths
        create_sprockets_environment()

        # we want a webserver that can provide the faye client javascript
        # and serve as a connection endpoint for faye pub/sub. this server
        # should also provide HTTP access to the sprockets environment.
        create_async_webserver_capable_of_supporting_faye()

        # whenever a file changes, we should compile it and send the data over
        # the pubsub.  the client should have the option of viewing both precompiled /
        # and compiled code, and a save in either the developers IDE or in the in-browser
        # code sync editor.
        publish_changes_detected_by_the_watcher_to_the_faye_pub_sub_channel()

        # allow the in-editor browser to edit precompiled assets and save the changes they
        # make to them to the file system.
        listen_for_changes_to_assets_made_in_browser_editor()
      end

      def method_missing meth, *args, &block
        puts "Need to implement #{ meth }"
      end
  end
end