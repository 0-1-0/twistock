Twitterexchange.Views.Flows ||= {}

class Twitterexchange.Views.Flows.InvestmentsView extends Backbone.View
  template: JST["backbone/templates/flows/investments"]

  render: ->
    $(@el).html(@template())
    return this
