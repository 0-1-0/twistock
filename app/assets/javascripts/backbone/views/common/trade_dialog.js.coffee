Twitterexchange.Views.Common ||= {}

class Twitterexchange.Views.Common.TradeDialog extends Backbone.View
  template: JST["backbone/templates/common/trade_dialog"]

  events:
    'click .close-dialog':        'destroy'
    'change .btn-checkbox input': 'switchMode'

  initialize: ->
    @parent_btn = @.options.parent_btn
    l = @

  render: ->
    $(@el).html(@template())
    @init_buy_slider()
    return this

  buttonToText: (btn) ->
    btn.removeClass('button primary secondary radius')
    btn.attr 'style', 'color: black; font-size: 20px; line-height: 40px;'

  normailizeButton: (btn) ->
    btn.attr 'style', ''
    btn.addClass('button radius')

  show: ->
    @$('.buy.dialog').fadeIn()
    $(@el).closest('.dialog-pin').addClass('active')

    @$('.checkbox').checkbox({cls:'checkbox'});

    @parent_btn.removeClass("secondary").addClass('alert buy-cancel')
    @parent_btn.data 'prev_text', @parent_btn.text()
    @parent_btn.text I18n.t 'buy_dialog.cancel'

    return this

  destroy: (e) ->
    if typeof e != 'undefined'
      e.preventDefault()

    @parent_btn.addClass("secondary").removeClass('alert buy-cancel')
    @parent_btn.text @parent_btn.data('prev_text')

    $(@el).closest('.dialog-pin').removeClass('active')
    @$('.buy.dialog').hide()
    $(@el).html ''

    return this


  switchMode: (e) ->
    x = $('.btn-checkbox input')
    block = x.parent()
    btn = x.closest(".dialog").find(".action")
    @normailizeButton(btn)
    block.find("a").toggleClass "active"
    if x.is(":checked")
      btn.removeClass("primary").addClass("secondary").text(I18n.t("buy_dialog.sell"))
      @init_sell_slider()
    else
      btn.removeClass("secondary").addClass("primary").text(I18n.t("buy_dialog.buy"))
      @init_buy_slider()
    false

  #
  init_buy_logic: ->
    link = @$(".buy.dialog .action")
    link.unbind()
    if @model.get('share_price') > current_user.get('money')
      @buttonToText(link)
      link.text(I18n.t('buy_dialog.no_money'))
      link.click (e) ->
        e.preventDefault()
      return

    link.click (e) =>
      e.preventDefault()
      count = $("#slider-price").slider('value')
      user_id = @model.get('id')
      link.unbind().text(I18n.t('buy_dialog.processing'))
      $.post "/api/users/#{user_id}/buy", { count: count }, =>
        current_user.fetch()
        if typeof flow_users != 'undefined'
          flow_users.get(user_id).fetch()
        if typeof window.user != 'undefined'
          window.user.fetch()
        if typeof window.tweets != 'undefined'
          tweets.where(user_id: user_id)[0].fetch()
        @destroy()

  #
  init_buy_slider: ->
    @$("#slider-price").unbind('slide')
    @$("#snum").remove()

    slide = @$("#slider-price")

    base_price      = @model.get('base_price')
    shares_in_stock = @model.get('shares_in_stock')
    money           = current_user.get('money')

    max_count       = StockMath.max_shares_to_buy(money, base_price, shares_in_stock)

    slide.slider
      value:  0
      min:    0
      max:    max_count
      slide: (event, ui) ->
        count           = parseInt(ui.value)
        $("#snum").html count
        $(".buy.dialog .buy-price").html "$#{ StockMath.buy_cost(count, base_price, shares_in_stock) }"

    @$(".buy.dialog .buy-price").html "$#{ StockMath.buy_cost(0, base_price, shares_in_stock) }"
    slide.find(".ui-slider-handle").append "<span id=\"snum\" class=\"snum\">" + slide.slider("value") + "</span>"

    @init_buy_logic()

  #
  init_sell_logic: ->
    link = $(".buy.dialog .action")
    link.unbind()
    if @model.get('purchased_shares') == 0
      @buttonToText(link)
      link.text(I18n.t('buy_dialog.no_shares'))
      link.click (e) ->
        e.preventDefault()
      return

    link.click (e) =>
      e.preventDefault()
      count = $("#slider-price").slider('value')
      user_id = @model.get('id')
      link.unbind().text(I18n.t('buy_dialog.processing'))
      $.post "/api/users/#{user_id}/sell", { count: count }, =>
        current_user.fetch()
        if typeof flow_users != 'undefined'
          flow_users.get(user_id).fetch()
        if typeof window.user != 'undefined'
          window.user.fetch()
        if typeof window.tweets != 'undefined'
          tweets.where(user_id: user_id)[0].fetch()

        @destroy()

  #
  init_sell_slider: ->
    @$("#slider-price").unbind('slide')
    @$("#snum").remove()

    slide = @$("#slider-price")

    base_price      = @model.get('base_price')
    shares_in_stock = @model.get('shares_in_stock')
    holded          = @model.get('purchased_shares')

    slide.slider
      value:  0
      min:    0
      max:    holded
      slide: (event, ui) ->
        count           = parseInt(ui.value)
        $("#snum").html count
        $(".buy.dialog .buy-price").html "$#{ StockMath.sell_cost(count, base_price, shares_in_stock) }"

    @$(".buy.dialog .buy-price").html "$#{ StockMath.sell_cost(0, base_price, shares_in_stock) }"
    slide.find(".ui-slider-handle").append "<span id=\"snum\" class=\"snum\">" + slide.slider("value") + "</span>"

    @init_sell_logic()
