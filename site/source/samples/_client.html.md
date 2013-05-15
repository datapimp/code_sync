The `CodeSync.Client` sits on top of a websocket connection, and listens for change notifications detected by the `CodeSync::Manager` component that runs on your local development environment.

Whenever a change to an asset pipeline asset is detected, the asset is compiled, and a notification is sent to the client, which then applies the updated assets to the running browser session.

```haml
html
  head
    = stylesheet_link_tag 'code_sync'
  body
    = javascript_include_tag 'code_sync'
    :javascript
      window.codeSyncClient = new CodeSync.Client()
```