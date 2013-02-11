
define "graph", ["utils","require", "getPerson"], (utils, getPerson, require) ->

  drag = d3.behavior.drag().on 'drag', ->
    dx = d3.event.dx
    dy = d3.event.dy
    d3.select(@).attr
      cx: (d) -> d.x += dx
      cy: (d) -> d.y += dy

    d3.selectAll('.link').attr
      x1: (d) -> d.from.x
      y1: (d) -> d.from.y
      x2: (d) -> d.to.x
      y2: (d) -> d.to.y

    d3.selectAll('.name').attr
      x: (d) -> d.x
      y: (d) -> d.y
      
  links = []
  create = (wiki) ->
    init()
    xscale = d3.scale.pow()
      .domain([parseInt(wiki.dob) - 50, parseInt(wiki.dob) + 50])
      .range([0, innerWidth])
        
    d3.select('.graph').append('circle').attr
      r: 50
      fill: 'url(#ocean_fill)'
      class: 'main'
      cy: innerHeight / 2
      cx: xscale(wiki.dob)
      
    d3.select('.graph').append('circle').attr
      r: 50
      fill: 'url(#globe_highlight)'
      class: 'main'
      cy: innerHeight / 2
      cx: xscale(wiki.dob)
      
    d3.select('.graph').append('text').text(wiki.name).attr
      fill: 'red'
      x: xscale(wiki.dob)
      y: innerHeight / 2
      
    dates = wiki.relations.map (d) -> parseInt(d.dob)
    min = d3.min(dates)
    max = d3.max(dates)
    start = new Date(min, 0, 1)
    end = new Date(max, 0, 1)
    time = d3.time.scale()
      .range([0, innerWidth])
      .domain([start, end])
      
    axis = d3.svg.axis()
      .scale(time)
      .orient('bottom')
      .ticks(10)

    d3.select('.time').call(axis)
    data = wiki.relations.map (data, index) ->
      text: data.name
      i: index
      x: xscale(parseInt(data.dob) or 1950)
      y: Math.random() * innerHeight
      fill: utils.rand_c()
      r: 15

    nodes = d3.select('.graph').selectAll('.node').data(data)
      .enter().append('circle')
      .on('click', (d)-> require.getPerson(d.text))
      .on('mouseover', ->
        d3.select(@).attr 'fill-opacity':1)
      .on('mouseout', -> d3.select(@).attr 'fill-opacity':.5)
      .attr
        class: 'relation'
        'fill-opacity': .5
        cx: (d) -> d.x
        cy: (d) -> d.y
        fill: (d) -> d.fill
      .call(drag)
      .transition()
      .duration(1000)
      .ease(d3.ease('cubic-in-out'))
      .delay((d, i) -> i * 50)
      .attr
        r: (d) -> d.r
        
    d3.selectAll('.relation').each (d, i) ->
      d3.select('.graph').append('text').datum(d)
        .text(d.text)
        .transition()
        .duration(1000)
        .delay(i * 50)
        .ease(d3.ease('cubic-in-out'))
        .attr
          class: 'name'
          x: (d) -> d.x - 5
          y: (d) -> d.y + 15
          fill: d.fill
          'font-family': 'deja vu sans mono'

    #TODO
    # convert lines to path
    # give links access to nodes
    d3.selectAll('.relation').data().forEach (b) ->
      a = d3.select('.main')
      a = {x: a.attr('cx'), y: a.attr('cy')}
      if 450 > utils.dist(a, b)
        links.push
          from: a
          to: b

    d3.select('.graph').selectAll('.link').data(links)
      .enter().insert('line', '*')
      .attr
        'stroke-width': 2
        'stroke-opacity': .01
        class: 'link'
        x1: (d) -> d.from.x
        y1: (d) -> d.from.y
        x2: (d) -> d.from.x
        y2: (d) -> d.from.y
        stroke: (d) -> d.to.fill
      .transition()
      .duration(5000)
      .ease(d3.ease('cubic'))
      .attr
        'stroke-opacity': .3
        x2: (d) -> d.to.x
        y2: (d) -> d.to.y

  init = ->
    body = d3.select('#graphContainer')
    svg = body.append('svg')
    grad = svg.append('defs').append('linearGradient')
      .attr
        id:'g952'
        gradientUnits: 'userSpaceonUse'
        x1:'0%'
        y1:'0%'
        y2:'100%'
        x2:'0%'
        r: '200%'
      .selectAll('stop').data(['#a7c8d6', '#7089b3'])
      .enter().append('stop').attr
        'stop-color': (d) -> d
        offset: (d, i) -> i
    graph = svg.append('g').attr('class','graph')
    brush = svg.append('g').attr('class','brush')
      .attr
        transform: "translate(0,#{innerHeight * .95})"
        stroke: 'blue`'
        fill: 'url(#g952)'
        'stroke-width': '1'
      .call(d3.svg.brush().x(d3.scale.identity().domain([0, innerWidth])))
      .on('brushstart', -> console.log 'strart')
      .on('brush', -> console.log 'brush')
      .on('brushend', -> console.log 'end')
      .selectAll('rect')
      .attr
        opacity: 1
        stroke: '#a5b8da'
        rx: '1.5%'
        height: '5%'

  return {
    create: create
  }
