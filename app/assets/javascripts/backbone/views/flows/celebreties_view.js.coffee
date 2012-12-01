Twitterexchange.Views.Flows ||= {}

class Twitterexchange.Views.Flows.CelebretiesView extends Backbone.View
  template: JST["backbone/templates/flows/celebreties"]

  render: ->
    $(@el).html(@template())
    return this
