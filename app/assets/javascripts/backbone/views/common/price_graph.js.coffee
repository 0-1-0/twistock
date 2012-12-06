Twitterexchange.Views.Common ||= {}

class Twitterexchange.Views.Common.PriceGraph extends Backbone.View
  template: JST["backbone/templates/common/price_graph"]

  initialize: ->
    @div_id   = @.options.div_id
    @data     = @.options.data
    this

  render: (data) ->
    $(@el).html(@template(div_id: @div_id))
    @drawGraph(data)
    return this

  drawGraph: ->
    #min =
    #max =
    container = $(@el).find("##{@div_id}")

    new Highcharts.Chart(
      chart:
        renderTo: container[0]
        backgroundColor: 'transparent'
        type: "area"
        width: 322
        height: 100
        spacingRight: 5
        spacingLeft: 5
        zoomType: 'xy'

      plotOptions:
        area:
          lineWidth: 1
          lineColor: '#367fa0'
          fillColor: '#1e9dcd'
          fillOpacity: 0.1


      legend:
        enabled: false

      title:
        text: null

      yAxis:
        #min: min
        #max: max
        gridLineWidth: 0
        startOnTick: false
        title:
          text: null
        labels:
          enabled: false

      xAxis:
        lineWidth: 0
        tickWidth: 0
        labels:
          enabled: false
        type: 'datetime'

      series: [
        name: "Share price"
        data: @data
      ]
    )

    container.find('tspan').hide()