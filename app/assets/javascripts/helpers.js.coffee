window.with_sign = (int) ->
  return '' if typeof int == "undefined"
  return '' if int == null

  if int >= 0
    "<span class=\"green\">+#{int}</span>"
  else
    "<span class=\"red\">#{int}</span>"


window.maybe_calculating = (model, attr) ->
  if model.get('share_price')
    model.get(attr)
  else
    if model.get('is_protected')
      I18n.t('status.share_price.unavailable')
    else
      I18n.t('status.share_price.calculating')


window.log10 = (x) ->
  Math.log(x) / Math.LN10

String::linkify_tweet = ->
  tweet = @replace(/[A-Za-z]+:\/\/[A-Za-z0-9-_]+\.[A-Za-z0-9-_:%&\?\/.=]+/g, (url) ->
    wrap = document.createElement("div")
    anch = document.createElement("a")
    anch.href = url
    anch.target = "_blank"
    anch.innerHTML = url
    wrap.appendChild anch
    wrap.innerHTML
  )
  tweet = tweet.replace(/(^|\s)@(\w+)/g, "$1<a href=\"http://www.twitter.com/$2\" target=\"_blank\">@$2</a>")
  tweet.replace /(^|\s)#((\w|А-Я|а-я)+)/g, "$1<a href=\"http://search.twitter.com/search?q=%23$2\" target=\"_blank\">#$2</a>"

window.StockMath =
  # стоимость покупки
  buy_cost: (count, base_price, shares_in_stock) ->
    shares_in_stock = shares_in_stock + count
    a = base_price/134000.0
    a = a * shares_in_stock*shares_in_stock
    q = 1 + 0.1*log10(a+1)

    Math.round(count*base_price*q)

  # стоимость продажи
  sell_cost: (count, base_price, shares_in_stock) ->
    -@buy_cost(-count, base_price, shares_in_stock)

  #
  max_shares_to_buy: (money, base_price, shares_on_stock) ->
    cost  = 0
    count = 0
    while cost < money
      count = count + 1
      cost = @buy_cost(count, base_price, shares_on_stock)
    count - 1