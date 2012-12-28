Twitterexchange.Views.Common ||= {}

class Twitterexchange.Views.Common.MailDialog extends Backbone.View
  template: JST["backbone/templates/common/mail_dialog"]

  events:
    'click #submit-mail': 'saveMail'

  initialize: ->
    this

  render: ->
    $(@el).html(@template())
    return this

  saveMail: ->
    @user = window.current_user
    @email = $('#input-mail-dialog').val()
    @money = @user.get('money')
    window.current_user.set({'email': @email})
    window.current_user.save()
    @$('.close-reveal-modal').click()
    $('#mail-dialog').hide()