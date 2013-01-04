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
    window.current_user.set({'email': @email})
    $.when(
      window.current_user.save()
    ).then =>
      window.current_user.fetch()
    
    @$('.close-reveal-modal').click()
    $('#mail-dialog').hide()