$(document).ready ->
  $('.btn-sell').click (e) ->
    $('#sell_modal #_owner').val $(@).attr('data-owner')
    $('#sell_modal #_count').val $(@).attr('data-count')
