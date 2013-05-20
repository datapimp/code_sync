(function() {

  window.backend || (window.backend = {});

  backend.authentication || (backend.authentication = {
    application_client_id: "1d70d6fe89bb1e381b5c",
    application_secret: "5d6578d2d8e38a251550cdf9d31dc2e349e328bf",
    authorization_token: "",
    user_digest: ""
  });

  backend.authenticate = function(username, password, callback) {
    if (!backend.authentication.authorization_token) {
      backend.createAuthorization(username, password, function() {
        return backend.authenticate(username, password);
      });
    }
    return backend.authentication;
  };

  backend.createAuthorization = function(username, password, callback) {
    return $.ajax({
      type: "GET",
      url: "https://api.github.com/authorizations",
      success: function(response) {
        var authorization;
        authorization = response[0];
        backend.authentication.authorization_token = authorization.token;
        return callback();
      },
      beforeSend: function(xhr) {
        return xhr.setRequestHeader("Authorization", "BASIC " + (backend.getDigest(username, password)));
      }
    });
  };

  backend.getDigest = function(username, password) {
    var value;
    if (value = backend.authentication.user_digest) {
      return value;
    }
    if (typeof btoa !== "undefined" && btoa !== null) {
      return backend.authentication.user_digest = btoa("" + username + ":" + password);
    }
  };

  backend.createGist = function(content) {
    var data, options;
    data = {
      description: "test gist",
      "public": false,
      content: content,
      files: {
        "data.js": content
      }
    };
    options = {
      type: "POST",
      url: "https://api.github.com/gists",
      data: JSON.stringify(data),
      contentType: "application/json",
      beforeRequest: function(xhr) {
        return xhr.setRequestHeader("Authorization", "token " + backend.authentication.authorization_token);
      },
      success: function(response) {
        return console.log("Response", response);
      },
      failure: function() {
        return console.log("failure!", arguments);
      }
    };
    console.log("options", options, data);
    return $.ajax(options);
  };

  backend.createGist("sup baby");

}).call(this);
