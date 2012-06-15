$(document).ready ->
  $('.btn-sell').click (e) ->
    $('#sell_modal #sell_owner').val $(@).attr('data-owner')
    $('#sell_modal #sell_count').val $(@).attr('data-count')
    $('#sell_modal #sell_origin').val $(@).attr('data-origin')

  window.setInterval (->
    $.get $(location).attr("href") + ".json", ((data) ->
      $("#price-box").html (if data.user.share_price then data.user.share_price else 'calculating...')
    ), "json"

  ), 1000
