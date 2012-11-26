$(document).ready ->

  # utility methods
  log10 = (val) ->
    Math.log(val) / Math.LN10

  # стоимость покупки
  buy_cost = (count, base_price, shares_in_stock) ->
    shares_in_stock = shares_in_stock + count
    a = base_price/134000.0
    a = a * shares_in_stock*shares_in_stock
    q = 1 + 0.1*log10(a+1)

    Math.round(count*base_price*q)

  # стоимость продажи
  sell_cost = (count, base_price, shares_in_stock) ->
    -buy_cost(-count, base_price, shares_in_stock)

  #
  max_shares_to_buy = (money, base_price, shares_on_stock) ->
    cost  = 0
    count = 0
    while cost < money
      count = count + 1
      cost = buy_cost(count, base_price, shares_on_stock)
    count - 1

  #
  init_buy_logic = () ->
    link = $("#buy-dialog .action")
    link.unbind()

    link.click (e) ->
      e.preventDefault()
      count = $("#slider-price").slider('value')
      user_id = $("#slider-price").data('user_id')
      $.post "/user/#{user_id}/buy", { count: count }
      window.location.reload()


  #
  init_sell_logic = () ->
    link = $("#buy-dialog .action")
    link.unbind()

    link.click (e) ->
      e.preventDefault()
      count = $("#slider-price").slider('value')
      user_id = $("#slider-price").data('user_id')
      $.post "/user/#{user_id}/sell", { count: count }
      window.location.reload()

  #
  init_buy_slider = ->
    $("#slider-price").unbind('slide')
    $("#snum").remove()

    slide = $("#slider-price")

    base_price      = slide.data 'base_price'
    shares_in_stock = slide.data 'shares_in_stock'
    money           = slide.data 'money'

    max_count       = max_shares_to_buy(money, base_price, shares_in_stock)

    slide.slider
      value:  0
      min:    0
      max:    max_count
      slide: (event, ui) ->
        count           = parseInt(ui.value)
        $("#snum").html count
        $("#buy-dialog .buy-price").html "$#{ buy_cost(count, base_price, shares_in_stock) }"

    $("#buy-dialog .buy-price").html "$#{ buy_cost(0, base_price, shares_in_stock) }"
    slide.find(".ui-slider-handle").append "<span id=\"snum\" class=\"snum\">" + slide.slider("value") + "</span>"

    init_buy_logic()

  #
  init_sell_slider = ->
    $("#slider-price").unbind('slide')
    $("#snum").remove()

    slide = $("#slider-price")

    base_price      = slide.data 'base_price'
    shares_in_stock = slide.data 'shares_in_stock'
    holded          = slide.data 'holded_shares'

    slide.slider
      value:  0
      min:    0
      max:    holded
      slide: (event, ui) ->
        count           = parseInt(ui.value)
        $("#snum").html count
        $("#buy-dialog .buy-price").html "$#{ sell_cost(count, base_price, shares_in_stock) }"

    $("#buy-dialog .buy-price").html "$#{ sell_cost(0, base_price, shares_in_stock) }"
    slide.find(".ui-slider-handle").append "<span id=\"snum\" class=\"snum\">" + slide.slider("value") + "</span>"

    init_sell_logic()
  #
  $(".btn-checkbox input").on "change", ->
    $this = $(this)
    block = $this.parent()
    btn = $this.closest(".dialog").find(".button")
    block.find("a").toggleClass "active"
    if not $this.is(":checked")
      btn.removeClass("secondary").addClass("primary").text("Buy")
      init_buy_slider()
    else
      btn.removeClass("primary").addClass("secondary").text("Sell")
      init_sell_slider()
    false

  action =
    modal: $("#buy-dialog")
    open: (elem) ->
      elem.removeClass("secondary buy-cancel").addClass("alert buy-cancel").text("Cancel").closest(".blk").addClass("active").append @modal.fadeIn()

    close: (elem) ->
      elem.removeClass("alert buy-cancel").addClass("secondary").text("Buy").closest(".blk").removeClass "active"
      @modal.hide()

  # Buy Btn
  $(".btn-buy").on "click", (e) ->
    e.preventDefault()

    # load user data
    user_id = $(@).attr 'data-id'
    $.getJSON "/user/#{user_id}/get_info.json", (data) ->
      user_link = $('#buy-dialog .user_link')
      user_link.text "@#{data.nickname}"
      user_link.attr 'href', data.user_link

      money           = parseInt(data.money)
      base_price      = parseInt(data.base_price)
      shares_in_stock = parseInt(data.shares_in_stock)
      holded_shares   = parseInt(data.holded_shares)

      $("#slider-price").data 'base_price',       base_price
      $("#slider-price").data 'shares_in_stock',  shares_in_stock
      $("#slider-price").data 'money',            money
      $("#slider-price").data 'holded_shares',    holded_shares
      $("#slider-price").data 'user_id',          user_id

      init_buy_slider()

    $(".dialog").fadeOut 160
    if $(this).hasClass("buy-cancel")
      action.close $(this)
    else
      action.close $(".btn-buy")
      action.open $(this)
    false

