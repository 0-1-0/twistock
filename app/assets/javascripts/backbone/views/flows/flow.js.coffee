Twitterexchange.Views.Flows ||= {}

class Twitterexchange.Views.Flows.Flow extends Backbone.View
  template: JST["backbone/templates/flows/flow"]

  initialize: ->
    @flow_type = @.options.flow_type

  render: ->
    $(@el).html(@template(type: @flow_type))
    $.when(@collection.fetch(data: {flow: @flow_type})).then =>
      @collection.each(@appendTile)

    return this

  appendTile: (user) ->
    if @flow_type == 'investment'
      type = 'inv'
    else
      type = 'std'

    view = new Twitterexchange.Views.Flows.Tile(model: user, type: type)
    @$('#tiles').append(view.render().el)
