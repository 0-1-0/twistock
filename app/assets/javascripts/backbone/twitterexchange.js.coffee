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
    window.trade_dialog = null

$(document).ready ->
  Twitterexchange.init()