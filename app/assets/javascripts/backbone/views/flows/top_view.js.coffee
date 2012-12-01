Twitterexchange.Views.Flows ||= {}

class Twitterexchange.Views.Flows.TopView extends Backbone.View
  template: JST["backbone/templates/flows/top"]

  render: ->
    $(@el).html(@template())
    return this
