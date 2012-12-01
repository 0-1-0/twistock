Twitterexchange.Views.Flows ||= {}

class Twitterexchange.Views.Flows.ExpensiveView extends Backbone.View
  template: JST["backbone/templates/flows/expensive"]

  render: ->
    $(@el).html(@template())
    return this
