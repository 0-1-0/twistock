Twitterexchange.Views.Flows ||= {}

class Twitterexchange.Views.Flows.InvestorsView extends Backbone.View
  template: JST["backbone/templates/flows/investors"]

  render: ->
    $(@el).html(@template())
    return this
