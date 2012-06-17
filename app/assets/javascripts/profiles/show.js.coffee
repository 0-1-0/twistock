$(document).ready ->
  $('.btn-sell').click (e) ->
    $('#sell_modal #sell_owner').val $(@).attr('data-owner')
    $('#sell_modal #sell_count').val $(@).attr('data-count')
    $('#sell_modal #sell_origin').val $(@).attr('data-origin')

  #Онлайн-обновление суммы при покупке
  $('#buy_modal #buy_count').change (e) ->
    $('#buy_modal #buy_total_cost').val  $('#buy_modal #buy_count').val()*$('#buy_modal #buy_price').val()

  #Онлайн-обновление суммы при продаже своих акций
  $('#sell_retention_modal #sell_count').change (e) ->
    $('#sell_retention_modal #sell_total_cost').val  $('#sell_retention_modal #sell_count').val()*$('#sell_retention_modal #sell_price').val()

  #Онлайн-обновление суммы при продаже чужих акций
  $('#sell_modal #sell_count').change (e) ->
    curr_total_count = $('#sell_modal #sell_total_count').val()
    curr_count = $('#sell_modal #sell_count').val()
    base_price = $('#sell_modal #sell_base_price').val()

    $('#sell_modal #sell_total_cost').val  Math.round(curr_count*base_price*(curr_total_count-curr_count+2000.0)/2000.0)
    

  setinterval_id = window.setInterval (->
    $.get $(location).attr("href") + ".json", ((data) ->
      if data.user.share_price 
        $("#price-box").html data.user.share_price
        $("#buy_modal #buy_count").val Math.round(0.9*current_money/data.user.share_price) 
        clearInterval(setinterval_id);
        

    ), "json"

  ), 1000
