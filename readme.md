- Sync asset pipeline changes with browser

  - File system watcher to detect changes to asset pipeline
    - Publishes changes to Faye server API

  - Faye server and Browser client for pub/sub notification
    - Change notification API / messaging structure

  - Browser client

  - Command line interface to interact with pub/sub 
    - Text editors plugin

  - Detect if running inside of rails, or middleman, and tap into Sprockets env 

  - Standalone mode for Sprockets

  - Monkeypatch Sprockets asset include to have identifier in DOM for stylesheets
    - find a way to map style tag href to asset pipeline path  

