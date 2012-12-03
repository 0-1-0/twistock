class Twitterexchange.Routers.FlowsRouter extends Backbone.Router
  initialize: (options) ->
    @collection = new Twitterexchange.Collections.UsersCollection()
    window.flow_users = @collection

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
    $("#flows_menu a#flow_top_link").addClass('active')
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection, flow_type: 'top')
    $("#main").html(@view.render().el)

  investments: ->
    $("#flows_menu a#flow_investments_link").addClass('active')
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection, flow_type: 'investments')
    $("#main").html(@view.render().el)

  investors: ->
    $("#flows_menu a#flow_investors_link").addClass('active')
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection, flow_type: 'investors')
    $("#main").html(@view.render().el)

  friends: ->
    $("#flows_menu a#flow_friends_link").addClass('active')
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection, flow_type: 'friends')
    $("#main").html(@view.render().el)

  expensive: ->
    $("#flows_menu a#flow_expensive_link").addClass('active')
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection, flow_type: 'expensive')
    $("#main").html(@view.render().el)

  celebreties: ->
    $("#flows_menu a#flow_celebreties_link").addClass('active')
    @view = new Twitterexchange.Views.Flows.Flow(collection: @collection, flow_type: 'celebreties')
    $("#main").html(@view.render().el)

