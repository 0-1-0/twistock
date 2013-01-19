Twitterexchange.Views.Common ||= {}

class Twitterexchange.Views.Common.RefDialog extends Backbone.View
  template: JST["backbone/templates/common/ref_dialog"]

  events:
    'click #haction': "showDialog"

  initialize: ->
    this

  render: ->
    $(@el).html(@template())
    return this

  showDialog: (e)->
    e.stopPropagation()
    $('#modal-ref').reveal()