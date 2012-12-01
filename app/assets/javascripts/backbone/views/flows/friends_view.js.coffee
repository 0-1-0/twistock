Twitterexchange.Views.Flows ||= {}

class Twitterexchange.Views.Flows.FriendsView extends Backbone.View
  template: JST["backbone/templates/flows/friends"]

  render: ->
    $(@el).html(@template())
    return this
