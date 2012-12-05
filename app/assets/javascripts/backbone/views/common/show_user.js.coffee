Twitterexchange.Views.Common ||= {}

class Twitterexchange.Views.Common.ShowUser extends Backbone.View
  template: JST["backbone/templates/common/show_user"]

  events:
    'click .btn-buy:not(.buy-cancel)':  'openTradeDialog'
    'click .btn-buy.buy-cancel':        'closeTradeDialog'

  initialize: ->
    @price_log = @.options.price_log
    @model.on('change', @render, this)
    this

  render: ->
    $(@el).html(@template(user: @model))
    @user_graph = new Twitterexchange.Views.Common.PriceGraph(div_id: 'show_user_graph', data: @price_log)
    $(@el).find('.grafic').html(@user_graph.render().el)

    @updateOuterData()

    return this

  updateOuterData: ->
    $('#user_p_count').text @model.get('purchased_shares')

    summary_cost = @model.get('purchased_shares')*@model.get('share_price')
    summary_change = with_sign(@model.get('purchased_shares')*@model.get('weekly_price_change'))

    $('#user_p_cost').html "$#{summary_cost} #{summary_change}"

  openTradeDialog: (e) ->
    e.preventDefault()

    if window.trade_dialog
      trade_dialog.destroy()

    window.trade_dialog = new Twitterexchange.Views.Common.TradeDialog(parent_btn: $(@el).find('.btn-buy'), model: @model)
    @$('.buy-dialog').html trade_dialog.render().el
    trade_dialog.show()

  closeTradeDialog: (e) ->
    e.preventDefault()
    trade_dialog.destroy()
