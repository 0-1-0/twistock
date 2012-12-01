class Twitterexchange.Routers.FlowsRouter extends Backbone.Router
  initialize: (options) ->
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
    @view = new Twitterexchange.Views.Flows.TopView()
    $("#main").html(@view.render().el)

  investments: ->
    @view = new Twitterexchange.Views.Flows.InvestmentsView()
    $("#main").html(@view.render().el)

  investors: ->
    @view = new Twitterexchange.Views.Flows.InvestorsView()
    $("#main").html(@view.render().el)

  friends: ->
    @view = new Twitterexchange.Views.Flows.FriendsView()
    $("#main").html(@view.render().el)

  expensive: ->
    @view = new Twitterexchange.Views.Flows.ExpensiveView()
    $("#main").html(@view.render().el)

  celebreties: ->
    @view = new Twitterexchange.Views.Flows.CelebretiesView()
    $("#main").html(@view.render().el)

