Twitterexchange.Views.Common ||= {}

class Twitterexchange.Views.Common.RefDialog extends Backbone.View
  template: JST["backbone/templates/common/ref_dialog"]

  initialize: ->
    this

  render: ->
    $(@el).html(@template())
    return this