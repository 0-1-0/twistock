$(document).ready ->
  $('.btn-sell').click (e) ->
    $('#sell_modal #sell_owner').val $(@).attr('data-owner')
    $('#sell_modal #sell_count').val $(@).attr('data-count')
    $('#sell_modal #sell_origin').val $(@).attr('data-origin')

  window.setInterval (->
    $.get $(location).attr("href") + ".json", ((data) ->
      if data.user.share_price 
        $("#buy_modal #buy_count").val Math.round(0.9*current_money/data.user.share_price) 
        $("#price-box").html data.user.share_price

    ), "json"

  ), 1000
