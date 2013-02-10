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

  drag = d3.behavior.drag().on 'drag', ->
    [dx, dy] = [d3.event.dx, d3.event.dx]
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

  links = []
  count = 0
  create = (wiki) ->
    return if !wiki.relations
    dates = wiki.relations.map (d) ->parseInt(d.dob)
    min = d3.min(dates)
    max = d3.max(dates)
    xscale = d3.scale.pow()
      .domain([1750, 1850])
      .range([0, innerWidth])
    return if (d3.selectAll('circle')[0].length > 30) 
    h = (window.innerHeight / 2) 
    w = (window.innerWidth / 2)
    count++
    return console.log(wiki) if (! wiki.relations)
    data = wiki.relations.map (data, index) ->
      console.log(data)
      text: data.name
      count:count
      i: index
      x: xscale(parseInt(data.dob) or 1950)
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
        cy: (d) -> d.y
        fill: (d) -> d.fill
      .call(drag)
      .transition()
      .duration(1000)
      .ease(d3.ease('cubic-in-out'))
      .delay((d, i) -> i * 50)
      .attr
        r: (d) -> d.r
    d3.selectAll('circle').data().forEach (d, i) ->
      d3.select('.graph').append('text').datum(d)
        .text(d.text)
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
      d3.selectAll('circle').data().forEach (b) ->
        if 150 > dist(a, b) and a != b
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
    date = new Date
    date.setYear(2000)
    time = d3.time.scale()
      .range([0, innerWidth - 50])
      .domain([date, new Date()])
      
    axis = d3.svg.axis()
      .scale(time)
      .orient('bottom')

    w = innerWidth
    h = innerHeight
    d3.select('svg')
      .append('g')
      .attr('class', 'time')
      .attr('transform', "translate(0, #{h * .97})")
      .call(axis)

  # test = "ocean"
  # test && jsonp(test, create)
  init()
  return {
    create: create
  }
