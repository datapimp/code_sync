window.backend ||= {}

backend.authentication ||=
  # there must be an application registered with github
  # whose domain matches the domain making the request to
  # the gist api on behalf of the user

  # this is set in the application registration
  application_client_id: "1d70d6fe89bb1e381b5c"

  # this is generated in the application settings and
  # will require the user to authenticate in their profile
  application_secret: "5d6578d2d8e38a251550cdf9d31dc2e349e328bf"

  # once a given user authenticates the registered application
  # there will be an authorization token stored against their account
  authorization_token: ""

  # base64 encoded username:password
  # used for http basic authentication to github api
  user_digest: ""

backend.authenticate = (username, password, callback)->
  unless backend.authentication.authorization_token
    backend.createAuthorization username, password, ()->
      backend.authenticate(username, password)

  backend.authentication

backend.createAuthorization = (username,password, callback)->
  $.ajax
    type: "GET"

    url: "https://api.github.com/authorizations"

    success: (response)->
      authorization = response[0]
      backend.authentication.authorization_token = authorization.token
      callback()

    beforeSend:(xhr)->
      xhr.setRequestHeader("Authorization", "BASIC #{ backend.getDigest(username,password) }" )

backend.getDigest = (username,password)->
  if value = backend.authentication.user_digest
    return value

  if btoa?
    backend.authentication.user_digest = btoa("#{username}:#{password}")

backend.createGist = (content)->
  data =
    description: "test gist"
    public: false
    content: content
    files:
      "data.js" : content

  options =
    type: "POST"
    url: "https://api.github.com/gists"
    data: JSON.stringify(data)
    contentType: "application/json"
    beforeRequest: (xhr)->
      #xhr.setRequestHeader("Authorization", "BASIC #{ backend.getDigest(username,password) }" )
      xhr.setRequestHeader("Authorization", "token #{ backend.authentication.authorization_token }")

    success: (response)->
      console.log "Response", response

    failure: ()->
      console.log "failure!", arguments

  console.log "options", options, data

  $.ajax(options)

backend.createGist("sup baby")
