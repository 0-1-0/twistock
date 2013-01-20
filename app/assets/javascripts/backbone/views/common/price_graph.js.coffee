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

    prices = _.map @data, (x) ->
      x[1]
    min = _.min(prices) - 6
    max = _.max(prices) + 6
    container = $(@el).find("##{@div_id}")

    # plotter(
    #   container: container[0]

    #   datas: [
    #     values: prices
    #     color: "#1e9dcd"
    #   ]

    #   width: 310
    #   height: 100
    #   fill:'solid'
    #   mode: 'curve'

    #   labels:
    #     color: "#666"
    #     font: "normal 12px \"Sans Serif\""
    #     x:1
    #     y:1

  
    # )

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
        min: min
        max: max
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