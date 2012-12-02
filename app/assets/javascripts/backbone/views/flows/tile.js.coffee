Twitterexchange.Views.Flows ||= {}

class Twitterexchange.Views.Flows.Tile extends Backbone.View
  std_template: JST["backbone/templates/flows/std_tile"]
  inv_template: JST["backbone/templates/flows/inv_tile"]

  tagName: 'li'

  initialize: ->
    @type = @.options.type

  render: ->
    if @type == 'std'
      $(@el).html(@std_template(user: @model))
    else
      $(@el).html(@inv_template(user: @model))
    return this
