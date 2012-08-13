$(document).ready ->
  $('.description-data').hide()

  $('.btn-buy').click (e) ->
    $('.order').hide()
    $('.pre-order').show()

    $('#buy_modal #create_product_name').val($(@).attr('product_name'))
    $('#buy_modal #create_total_cost').val($(@).attr('total_cost'))
    $('#buy_modal #create_product_id').val($(@).attr('product_id'))
    $('#productname').html($(@).attr('product_name'))
    $('#description').html($(@).parent().find('.description-data').html())

  $('#btn-order').click (e) ->
    $('.order').show()
    $('.pre-order').hide()

  $('#btn-buy-finish').click(e) ->
    alert('Thank you for your purchase!')