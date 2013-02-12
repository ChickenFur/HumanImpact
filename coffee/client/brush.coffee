define () ->
  exp = (scale, cb) ->
    svg = d3.select('svg')
    b = d3.svg.brush()
      .x(scale)
      .on('brush', -> cb(b))
      brush = svg.append('g')
    .attr
        class: 'brush'
        transform: "translate(0,#{innerHeight * .94})"
        stroke: 'blue`'
        fill: 'url(#brush)'
        'stroke-width': '1'
      .call(b)
      .selectAll('rect')
      .attr
        opacity: .5
        stroke: '#a5b8da'
        rx: '1.5%'
        height: '5%'
        # width: innerWidth - 40
        # x: 15

