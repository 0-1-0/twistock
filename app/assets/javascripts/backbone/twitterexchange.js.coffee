#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

window.Twitterexchange =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

  init: ->
    user = new Twitterexchange.Models.User({id: 1})
    user.fetch()
    true

$(document).ready ->
  Twitterexchange.init()