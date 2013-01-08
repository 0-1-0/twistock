Twitterexchange.Views.Common ||= {}

Array::chunk = (chunkSize) ->
  array = this
  [].concat.apply [], array.map((elem, i) ->
    (if i % chunkSize then [] else [array.slice(i, i + chunkSize)])
  )

class Twitterexchange.Views.Common.ShowUser extends Backbone.View
  template: JST["backbone/templates/common/show_user"]

  events:
    'click .btn-buy:not(.buy-cancel)':  'openTradeDialog'
    'click .btn-buy.buy-cancel':        'closeTradeDialog'
    'click .page_switch':       'page_switch'

  initialize: ->
    @price_log = @.options.price_log

    @portfel      = new Twitterexchange.Collections.BlockOfShares()
    @my_shares    = new Twitterexchange.Collections.BlockOfShares()

    @model.on('change', @render, this)
    this

  render: ->
    $.when(
      @portfel.fetch(data: {type: 'portfel', user_id: @model.get('id')}),
      @my_shares.fetch(data: {type: 'my_shares', user_id: @model.get('id')})
    ).then =>
      portfel_pages   = @portfel.models.chunk(10)
      my_shares_pages = @my_shares.models.chunk(10)
      $(@el).html(@template(user: @model, portfel: portfel_pages, my_shares: my_shares_pages))

      @$('#portfel tr[page=1]').show()
      @$('#my_shares tr[page=1]').show()
      @$('.page_switch[page=1]').addClass('active').attr('style', 'color: black;')

      @user_graph = new Twitterexchange.Views.Common.PriceGraph(div_id: 'show_user_graph', data: @price_log)
      $(@el).find('.grafic').html(@user_graph.render().el)

      unless @model.get('purchased_shares') > 0
        @$('#invdata').hide()
      else
        @$('#invdata').show()

    return this

  page_switch: (e) ->
    e.preventDefault()

    x = $(e.target)
    p = x.parent()

    p.find('.page_switch.active').removeClass('active').removeAttr('style')
    x.addClass('active').attr('style', 'color: black;')

    page = x.attr('page')
    p.find("table tr[page=#{page}]").show()
    p.find("table tr[page!=#{page}]").hide()


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
