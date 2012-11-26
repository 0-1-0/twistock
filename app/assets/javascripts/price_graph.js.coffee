$(document).ready ->
  window.draw_graph = (data, container, min, max) ->
    new Highcharts.Chart(
      chart:
        renderTo: container
        backgroundColor: 'transparent'
        type: "area"
        width: 322
        height: 100
        spacingRight: 5
        spacingLeft: 5
        zoomType: 'x'

      plotOptions:
        area:
          lineWidth: 1
          lineColor: 'blue'


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
        data: data
      ]
    )

    $("##{container} tspan").hide()