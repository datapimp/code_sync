backend = {}

backend.authentication = {}
  # there must be an application registered with github
  # whose domain matches the domain making the request to
  # the gist api on behalf of the user

  # this is set in the application registration
  application_client_id: ""

  # this is generated in the application settings and
  # will require the user to authenticate in their profile
  application_secret: ""

  # once a given user authenticates the registered application
  # there will be an authorization token stored against their account
  authorization_token: ""

  # base64 encoded username:password
  # used for http basic authentication to github api
  user_digest: ""


backend.createAuthorization = (success)->
  $.ajax
    type: "GET"
    url: "https://api.github.com/authorizations"

    success: ()->
      debugger

    beforeSend:(xhr)->
      xhr.setRequestHeader("Authorization", "BASIC #{ backend.getDigest(username,password) }" )

backend.getDigest = (username,password)->
  if value = backend.authentication.user_digest
    return value

  if btoa?
    btoa("#{username}:#{password}")
