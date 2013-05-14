```haml
html
  head
    = stylesheet_link_tag 'code_sync'
  body
    = javascript_include_tag 'code_sync'
    :javascript
      window.codeSyncClient = new CodeSync.Client()
```