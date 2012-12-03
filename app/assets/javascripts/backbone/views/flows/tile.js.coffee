Twitterexchange.Views.Flows ||= {}

class Twitterexchange.Views.Flows.Tile extends Backbone.View
  std_template: JST["backbone/templates/flows/std_tile"]
  inv_template: JST["backbone/templates/flows/inv_tile"]

  tagName: 'li'

  events:
    'click .btn-buy:not(.buy-cancel)':  'openTradeDialog'
    'click .btn-buy.buy-cancel':        'closeTradeDialog'

  initialize: ->
    @type = @.options.type

  render: ->
    if @type == 'std'
      $(@el).html(@std_template(user: @model))
    else
      $(@el).html(@inv_template(user: @model))
    return this

  openTradeDialog: (e) ->
    e.preventDefault()

    if window.trade_dialog
      trade_dialog.destroy()

    window.trade_dialog = new Twitterexchange.Views.Common.TradeDialog(parent_btn: $(@el).find('.btn-buy'), model: @model)
    @$('span.buy-dialog').html trade_dialog.render().el
    trade_dialog.show()

  closeTradeDialog: (e) ->
    e.preventDefault()
    trade_dialog.destroy()
