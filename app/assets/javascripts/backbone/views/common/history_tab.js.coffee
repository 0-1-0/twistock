Twitterexchange.Views.Common ||= {}

class Twitterexchange.Views.Common.HistoryTab extends Backbone.View
  template: JST["backbone/templates/common/history_tab"]

  initialize: ->
    this

  render: ->
    $(@el).html(@template(transactions: @collection))
    return this