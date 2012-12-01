Twitterexchange.Views.Flows ||= {}

class Twitterexchange.Views.Flows.Flow extends Backbone.View
  template: JST["backbone/templates/flows/flow"]

  #initialize: ->
  #  @flow_type = @.options.flow_type

  render: (flow_type) ->
    $.when(@collection.fetch(data: {flow: flow_type})).then =>
      $(@el).html(@template(type: @flow_type, users: @collection))
    return this
