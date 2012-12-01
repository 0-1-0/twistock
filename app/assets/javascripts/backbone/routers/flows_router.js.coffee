class Twitterexchange.Routers.FlowsRouter extends Backbone.Router
  initialize: (options) ->
    @collection = new Twitterexchange.Collections.UsersCollection()

    $('#flows_menu a:not(.curr)').click (e) ->
      $('#flows_menu a').removeClass('active')
      $(@).addClass('active')

  routes:
    "": "top"
    "top": "top"
    "investments": "investments"
    "investors": "investors"
    "friends": "friends"
    "expensive": "expensive"
    "celebreties": "celebreties"
  
  top: ->
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection)
    $("#main").html(@view.render('top').el)

  investments: ->
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection)
    $("#main").html(@view.render('investments').el)

  investors: ->
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection)
    $("#main").html(@view.render('investors').el)

  friends: ->
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection)
    $("#main").html(@view.render('friends').el)

  expensive: ->
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection)
    $("#main").html(@view.render('expensive').el)

  celebreties: ->
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection)
    $("#main").html(@view.render('celebreties').el)

