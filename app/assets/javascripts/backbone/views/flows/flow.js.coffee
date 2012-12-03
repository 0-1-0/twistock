Twitterexchange.Views.Flows ||= {}

class Twitterexchange.Views.Flows.Flow extends Backbone.View
  template: JST["backbone/templates/flows/flow"]

  initialize: ->
    @collection   = new Twitterexchange.Collections.UsersCollection()
    @flow_type    = @.options.flow_type

    if @flow_type == "investments"
      @collection.on('change', @render, this)
      @collection.on('reset', @updateFlowMenuCounters, this)
    if @flow_type == "investors"
      @collection.on('reset', @updateFlowMenuCounters, this)

  render: ->
    window.flow_users = @collection
    if @flow_type == "investments"
      stats =
        total_cost:     0
        daily_change:   0
        weekly_change:  0
        monthly_change: 0

      $.when(@collection.fetch(data: {flow: @flow_type})).then =>
        @collection.each (user) ->
          mult = user.get('purchased_shares')
          stats.total_cost      += user.get('share_price')          * mult
          stats.daily_change    += user.get('daily_price_change')   * mult
          stats.weekly_change   += user.get('weekly_price_change')  * mult
          stats.monthly_change  += user.get('monthly_price_change') * mult
        $(@el).html(@template(type: @flow_type, stats: stats))
        @collection.each(@appendTile, this)
    else
      $(@el).html(@template(type: @flow_type))
      $.when(@collection.fetch(data: {flow: @flow_type})).then =>
        @collection.each(@appendTile, this)

    return this

  appendTile: (user) ->
    type = 'std'
    type = 'inv' if @flow_type == 'investments'

    view = new Twitterexchange.Views.Flows.Tile(model: user, type: type)
    @$('#tiles').append(view.render().el)

  updateFlowMenuCounters: ->
    if @flow_type == 'investments'
      $('span#investments_count').text @collection.length
    if @flow_type == 'investors'
      $('span#investors_count').text @collection.length
