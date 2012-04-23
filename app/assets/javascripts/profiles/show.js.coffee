$(document).ready ->
  $('.btn-sell').click (e) ->
    $('#sell_modal #sell_owner').val $(@).attr('data-owner')
    $('#sell_modal #sell_count').val $(@).attr('data-count')
