define "graph", () ->
  log = -> window.debug != false && console.log.apply(console, arguments)

  dist = (a, b) ->
    xd = a.x - b.x
    yd = a.y - b.y
    Math.sqrt(xd * xd + yd * yd)

  mirror = (f) ->
    if "function" != typeof f then f = d3.ease.apply(d3, arguments) 
    (t) -> if t < .5 then f(2 * t) else f(2 - 2 * t) 

  rand_c = ->
    '#' + (0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6)

  jsonp =  (query, callback) ->
    window.__cb__ = callback or -> log(arguments)
    d3.select('head').append('script').attr('src', urls.search(query))

  drag = d3.behavior.drag().on 'drag', ->
    dx = d3.event.dx
    dy = d3.event.dy
    d3.select(@).attr
      cx: (d) -> d.x += dx
      cy: (d) -> d.y += dy

    d3.selectAll('line').attr
      x1: (d) -> d.from.x
      y1: (d) -> d.from.y
      x2: (d) -> d.to.x
      y2: (d) -> d.to.y

    d3.selectAll('text').attr
      x: (d) -> d.x
      y: (d) -> d.y
  dist = (a, b) ->
    xd = a.x - b.x
    yd = a.y - b.y
    Math.sqrt(xd * xd + yd * yd)

  xscale = d3.scale.linear()
    .domain([-500, 2000])
    .range([0, 1000])

  links = []
  count = 0
  create = (wiki) ->
    return if (d3.selectAll('circle')[0].length > 30) 
    h = (window.innerHeight / 2) 
    w = (window.innerWidth / 2)
    count++
    return console.log(wiki) if (! wiki.relations) 
    data = wiki.relations.map (data, index) ->
      text: data.name
      count:count
      i: index
      x: Math.random() * innerHeight
      y: Math.random() * innerHeight
      fill: rand_c()
      r: 15

    nodes = d3.select('.graph').selectAll('.node').data(data)
      .enter().append('circle')
      .on('mouseover', ->
        d3.select(@).attr 'fill-opacity':1)
      .on('mouseout', -> d3.select(@).attr 'fill-opacity':.5)
      .attr
        'fill-opacity': .5
        cx: (d) -> d.x
        cy: (d) -> d.dob
        fill: (d) -> d.fill
      .call(drag)
      .transition()
      .duration(1000)
      .ease(d3.ease('cubic-in-out'))
      .delay((d, i) -> i * 50)
      .attr
        r: (d) -> d.r
    nodes.each (d, i) ->
      return 10
      d3.select('.graph').append('text').datum(d)
        .text(d.text.replace(/_/g,' '))
        .transition()
        .ease(d3.ease('cubic-in-out'))
        .attr
          x: (d) -> d.x - 5
          y: (d) -> d.y + 30
          fill: d.fill
          'font-family': 'deja vu sans mono'

    #TODO
    # convert lines to path
    # give links access to nodes
    d3.selectAll('circle').data().forEach (a) ->
      return if Math.random() > .99
      d3.selectAll('circle').data().forEach (b) ->
        if 250 > dist(a, b) and a != b
          links.push
            from: a
            to: b
    console.log(links)
    d3.select('.graph').selectAll('line').data(links)
      .enter().insert('line', '*')
      .attr
        'stroke-width': 2
        'stroke-opacity': .01
        x1: (d) -> d.from.x
        y1: (d) -> d.from.y
        x2: (d) -> d.from.x
        y2: (d) -> d.from.y
        stroke: (d) -> d.from.fill
      .transition()
      .duration(5000)
      .ease(d3.ease('cubic'))
      .attr
        'stroke-opacity': .3
        x2: (d) -> d.to.x
        y2: (d) -> d.to.y
  init = ->
    body = d3.select('body')
    svg = body.append('svg')
    grad = svg.append('linearGradient')
      .attr
        id:'g952'
        gradientUnits: 'userSpaceonUse'
        x1:'0%'
        y1:'0%'
        y2:'100%'
        x2:'0%'
        r: '200%'
      .selectAll('stop').data(['#C7EEFF', '#7089b3'])
      .enter().append('stop').attr
        'stop-color': (d) -> d
        offset: (d, i) -> i
    graph = svg.append('g').attr('class','graph')
    brush = svg.append('g').attr('class','brush')
      .attr
        transform: "translate(0,#{innerHeight * .8})"
        stroke: 'blue`'
        fill: 'url(#g952)'
        'stroke-width': '1'
      .call(d3.svg.brush().x(d3.scale.identity().domain([0, innerWidth])))
      .on('brushstart', -> console.log 'strart')
      .on('brush', -> console.log 'brush')
      .on('brushend', -> console.log 'end')
      .selectAll('rect')
      .attr
        stroke: '#a5b8da'
        rx: '5%'
        height: '100px'

  # test = "ocean"
  # test && jsonp(test, create)
  init()
  return {
    create: create
  }
