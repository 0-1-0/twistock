$(document).ready ->
  $('.btn-buy').click (e) ->
    $('#buy_modal #buy_product_name').val($(@).attr('product_name'))
    $('#buy_modal #buy_total_cost').val($(@).attr('total_cost'))