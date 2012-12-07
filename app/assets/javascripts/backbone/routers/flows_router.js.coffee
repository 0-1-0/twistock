class Twitterexchange.Routers.FlowsRouter extends Backbone.Router
  initialize: (options) ->
    window.flow_users = null

    @view_top         = new Twitterexchange.Views.Flows.Flow(flow_type: 'top')
    @view_investments = new Twitterexchange.Views.Flows.Flow(flow_type: 'investments')
    @view_investors   = new Twitterexchange.Views.Flows.Flow(flow_type: 'investors')
    @view_friends     = new Twitterexchange.Views.Flows.Flow(flow_type: 'friends')
    @view_expensive   = new Twitterexchange.Views.Flows.Flow(flow_type: 'expensive')
    @view_celebreties = new Twitterexchange.Views.Flows.Flow(flow_type: 'celebreties')
    @active = @view_top


    # Infinity scroll
    $(window).scroll (e) =>
      if ($(window).scrollTop() + $(window).height() == $(document).height())
        @active.add_tiles()


  routes:
    "": "top"
    "top": "top"
    "investments": "investments"
    "investors": "investors"
    "friends": "friends"
    "expensive": "expensive"
    "celebreties": "celebreties"
  
  top: ->
    $('#flows_menu a').removeClass('active')
    $("#flows_menu a#flow_top_link").addClass('active')
    $("#main").html(@view_top.render().el)
    @active = @view_top

  investments: ->
    $('#flows_menu a').removeClass('active')
    $("#flows_menu a#flow_investments_link").addClass('active')
    $("#main").html(@view_investments.render().el)
    @active = @view_investments

  investors: ->
    $('#flows_menu a').removeClass('active')
    $("#flows_menu a#flow_investors_link").addClass('active')
    $("#main").html(@view_investors.render().el)
    @active = @view_investors

  friends: ->
    $('#flows_menu a').removeClass('active')
    $("#flows_menu a#flow_friends_link").addClass('active')
    $("#main").html(@view_friends.render().el)
    @active = @view_friends

  expensive: ->
    $('#flows_menu a').removeClass('active')
    $("#flows_menu a#flow_expensive_link").addClass('active')
    $("#main").html(@view_expensive.render().el)
    @active = @view_expensive

  celebreties: ->
    $('#flows_menu a').removeClass('active')
    $("#flows_menu a#flow_celebreties_link").addClass('active')
    $("#main").html(@view_celebreties.render().el)
    @active = @view_celebreties

