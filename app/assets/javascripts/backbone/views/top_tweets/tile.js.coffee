Twitterexchange.Views.TopTweets ||= {}

class Twitterexchange.Views.TopTweets.Tile extends Backbone.View
  template: JST["backbone/templates/top_tweets/tile"]

  tagName: 'div'

  events:
    'click .btn-buy:not(.buy-cancel)':  'openTradeDialog'
    'click .btn-buy.buy-cancel':        'closeTradeDialog'

  initialize: ->
    @simple = @.options.simple
    @model.on('change', @render, this)
    this

  render: ->
    if @simple
      $(@el).addClass('box fixh').html(@template(tweet: @model))
    else
      $(@el).addClass('box hidden').html(@template(tweet: @model))
    return this

  openTradeDialog: (e) ->
    e.preventDefault()

    if window.trade_dialog
      trade_dialog.destroy()

    user = new Twitterexchange.Models.User
      id:               @model.get('user_id')
      share_price:      @model.get('user_share_price')
      base_price:       @model.get('user_base_price')
      purchased_shares: @model.get('user_purchased_shares')
      shares_in_stock:  @model.get('user_shares_in_stock')

    window.trade_dialog = new Twitterexchange.Views.Common.TradeDialog(parent_btn: $(@el).find('.btn-buy'), model: user)
    @$('.buy-dialog').html trade_dialog.render().el
    trade_dialog.show()

  closeTradeDialog: (e) ->
    e.preventDefault()
    trade_dialog.destroy()
