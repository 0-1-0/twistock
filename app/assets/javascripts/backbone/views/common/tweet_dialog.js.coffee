Twitterexchange.Views.Common ||= {}

class Twitterexchange.Views.Common.TweetDialog extends Backbone.View
  template: JST["backbone/templates/common/tweet_dialog"]

  events:
    'click .close-dialog':  'destroy'
    'click .action': 'sendTweet'

  initialize: ->
    @parent_btn = @.options.parent_btn
    l = @

  render: ->
    $(@el).html(@template())
    return this


  show: ->
    @$('.tweet.dialog').fadeIn()
    $(@el).closest('.dialog-pin').addClass('active')

    @parent_btn.removeClass("secondary").addClass('alert tweet-cancel')
    @parent_btn.data 'prev_text', @parent_btn.text()
    @parent_btn.text I18n.t 'buy_dialog.cancel'

    offset = @parent_btn.offset()
    offset.top -= 160
    offset.left -= 160
    $('.tweet.dialog').offset(offset)


    return this

  destroy: (e) ->
    if typeof e != 'undefined'
      e.preventDefault()

    @parent_btn.addClass("secondary").removeClass('alert tweet-cancel')
    @parent_btn.text @parent_btn.data('prev_text')

    $(@el).closest('.dialog-pin').removeClass('active')
    @$('.tweet.dialog').hide()
    $(@el).html ''

    return this

  sendTweet: (e) ->
    msg = $('#tweet_textarea').val()
    $.ajax(
      type: "POST"
      url: '/api/users/' + current_user.get("id") + '/tweet'
      data: 
        message: msg
      success: (d)->
        console.log(d)
      dataType: 'json'
    )
    @destroy()