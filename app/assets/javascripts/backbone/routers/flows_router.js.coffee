class Twitterexchange.Routers.FlowsRouter extends Backbone.Router
  initialize: (options) ->
    window.flow_users = null

    $('#flows_menu a:not(.curr)').click (e) ->
      $('#flows_menu a').removeClass('active')
      $(@).addClass('active')

    @view_top         = new Twitterexchange.Views.Flows.Flow(flow_type: 'top')
    @view_investments = new Twitterexchange.Views.Flows.Flow(flow_type: 'investments')
    @view_investors   = new Twitterexchange.Views.Flows.Flow(flow_type: 'investors')
    @view_friends     = new Twitterexchange.Views.Flows.Flow(flow_type: 'friends')
    @view_expensive   = new Twitterexchange.Views.Flows.Flow(flow_type: 'expensive')
    @view_celebreties = new Twitterexchange.Views.Flows.Flow(flow_type: 'celebreties')


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
    $("#main").html(@view_top.render().el)

  investments: ->
    $("#flows_menu a#flow_investments_link").addClass('active')
    $("#main").html(@view_investments.render().el)

  investors: ->
    $("#flows_menu a#flow_investors_link").addClass('active')
    $("#main").html(@view_investors.render().el)

  friends: ->
    $("#flows_menu a#flow_friends_link").addClass('active')
    $("#main").html(@view_friends.render().el)

  expensive: ->
    $("#flows_menu a#flow_expensive_link").addClass('active')
    $("#main").html(@view_expensive.render().el)

  celebreties: ->
    $("#flows_menu a#flow_celebreties_link").addClass('active')
    $("#main").html(@view_celebreties.render().el)

