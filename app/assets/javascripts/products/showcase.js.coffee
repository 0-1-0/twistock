$(document).ready ->
  $('.btn-buy').click (e) ->
    $('#buy_modal #create_product_name').val($(@).attr('product_name'))
    $('#buy_modal #create_total_cost').val($(@).attr('total_cost'))
    $('#buy_modal #create_product_id').val($(@).attr('product_id'))

  $('.btn-buy-finish').click(e) ->
    alert('Thank you for your purchase!')