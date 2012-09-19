$(document).ready ->
  $('.btn-sell').click (e) ->
    $('#sell_modal #sell_owner').val $(@).attr('data-owner')
    $('#sell_modal #sell_count').val $(@).attr('data-count')
    $('#sell_modal #sell_origin').val $(@).attr('data-origin')


  CalculatePrice = (base_price,shares_count)->
    d = (Math.log(2*shares_count + 10))/Math.LN10
    d = d*d*d
    d = d*d
    return Math.round(base_price + d)

  #Онлайн-обновление суммы при покупке
  $('#buy_modal #buy_count').change (e) ->
    count = $('#buy_modal #buy_count').val()

    if count < 0
      $('#buy_modal #buy_count').val(0)
    else
      new_price = CalculatePrice(owner.base_price, owner.shares_count + count)
      $('#buy_modal #buy_total_cost').val new_price*count

    # $.post '/profiles/price_after_transaction', 
    #   {
    #     id:    $('#buy_modal #buy_owner').val(),
    #     count: $('#buy_modal #buy_count').val()
    #   },
    #   ((new_price) ->
    #     $('#buy_modal #buy_price').val new_price 
    #     $('#buy_modal #buy_total_cost').val new_price*$('#buy_modal #buy_count').val()
    #   ), "json"

  
  #Онлайн-обновление суммы при продаже чужих акций
  $('#sell_modal #sell_count').change (e) ->
    count = $('#sell_modal #sell_count').val()

    if count < 0
      $('#sell_modal #sell_count').val(0)
    else
      new_price = CalculatePrice(owner.base_price, owner.shares_count - count)
      $('#sell_modal #sell_total_cost').val new_price*count
    # $.post '/profiles/price_after_transaction',
    #   {
    #       id:    $('#sell_modal #sell_owner').val(),
    #       count: -$('#sell_modal #sell_count').val()
    #     },
    #     ((new_price) ->
    #       $('#sell_modal #sell_price').val new_price 
    #       $('#sell_modal #sell_total_cost').val new_price*$('#sell_modal #sell_count').val()
    #     ), "json"
    

  setinterval_id = window.setInterval (->
    $.get $(location).attr("href") + ".json", ((data) ->
      if data.user.share_price 
        $(".info").html(I18n.t('one_stock_price') + ': $' + data.user.share_price.toMoney())
        $('#buy_modal #buy_price').val data.user.share_price
        # $("#buy_modal #buy_count").val Math.round(0.9*current_money/data.user.share_price) 
        $('#buy_modal #buy_total_cost').val $('#buy_modal #buy_price').val()#*$("#buy_modal #buy_count").val()
        clearInterval(setinterval_id);
        

    ), "json"

  ), 1000
