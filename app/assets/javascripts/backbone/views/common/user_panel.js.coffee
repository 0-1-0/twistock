Twitterexchange.Views.Common ||= {}

class Twitterexchange.Views.Common.UserPanel extends Backbone.View
  template: JST["backbone/templates/common/user_panel"]

  initialize: ->
    @user = current_user
    @user.on('change', @render, this)

  render: ->
    $(@el).html(@template(user: @user))
    return this
