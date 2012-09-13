$(document).ready ->
  $('.btn-sell').click (e) ->
    $('#sell_modal #sell_owner').val $(@).attr('data-owner')
    $('#sell_modal #sell_count').val $(@).attr('data-count')
    $('#sell_modal #sell_origin').val $(@).attr('data-origin')

  #Онлайн-обновление суммы при покупке
  $('#buy_modal #buy_count').change (e) ->
    $('#buy_modal #buy_total_cost').val  $('#buy_modal #buy_count').val()*$('#buy_modal #buy_price').val()

  
  #Онлайн-обновление суммы при продаже чужих акций
  $('#sell_modal #sell_count').change (e) ->
    total_count = $('#sell_modal #sell_total_count').val()
    curr_count = $('#sell_modal #sell_count').val()
    base_price = $('#sell_modal #sell_base_price').val()
    curr_delta = (total_count - curr_count)
    d = Math.pow(curr_delta, 6)

    $('#sell_modal #sell_price').val(base_price + d)
    $('#sell_modal #sell_total_cost').val $('#sell_modal #sell_price').val()*$('#sell_modal #sell_count').val()
    

  setinterval_id = window.setInterval (->
    $.get $(location).attr("href") + ".json", ((data) ->
      if data.user.share_price 
        $(".info").html(I18n.t('one_stock_price') + ': $' + data.user.share_price.toMoney())
        $('#buy_modal #buy_price').val data.user.share_price
        $("#buy_modal #buy_count").val Math.round(0.9*current_money/data.user.share_price) 
        $('#buy_modal #buy_total_cost').val $('#buy_modal #buy_price').val()*$("#buy_modal #buy_count").val()
        clearInterval(setinterval_id);
        

    ), "json"

  ), 1000
