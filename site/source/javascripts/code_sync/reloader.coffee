#= require ./config
#= require ./client
#= require ./change-handling
#= require_self
#

unless _?
  throw "CodeSync depends on the underscore library at this time"
