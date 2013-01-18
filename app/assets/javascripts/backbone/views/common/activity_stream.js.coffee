Twitterexchange.Views.Common ||= {}

class Twitterexchange.Views.Common.ActivityStream extends Backbone.View
  template: JST["backbone/templates/common/activity_stream"]

  initialize: ->
    @user_id = @.options.user_id
    this

  render: ->
    flow = new Twitterexchange.Collections.ActivityEvents()
    $.when(flow.fetch(data: {user_id: @user_id})).then =>
      $(@el).html(@template(flow: flow))
    return this