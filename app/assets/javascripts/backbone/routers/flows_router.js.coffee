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
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection, flow_type: 'top')
    $("#main").html(@view.render().el)

  investments: ->
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection, flow_type: 'investments')
    $("#main").html(@view.render().el)

  investors: ->
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection, flow_type: 'investors')
    $("#main").html(@view.render().el)

  friends: ->
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection, flow_type: 'friends')
    $("#main").html(@view.render().el)

  expensive: ->
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection, flow_type: 'expensive')
    $("#main").html(@view.render().el)

  celebreties: ->
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection, flow_type: 'celebreties')
    $("#main").html(@view.render().el)

