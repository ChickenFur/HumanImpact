fixtures =
  a: 10

#utils
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

urls =
  search: (q) ->
    "http://en.wikipedia.org/w/api.php?" +
    "action=query&" +
    "list=search&" +
    "srprop=links&" +
    "format=json&" +
    "callback=__cb__&" +
    "srsearch=" + q
  relevance: (q) ->
    "action=query&" +
    "prop=categories&" +
    "format=json&" +
    "callback=__cb__&" +
    "titles=" + query

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

scale = d3.scale.linear()
  .domain([0,9])
  .range([0, Math.PI * 2])

links = []
count = 0
create = (wiki) ->
  return if (d3.selectAll('circle')[0].length > 30) 
  console.log wiki
  h = (window.innerHeight / 2) 
  w = (window.innerWidth / 2)
  count++
  wiki.query.search.forEach (obj, index) ->
    obj.count = count
    obj.i = index
    obj.x = 75 * count * Math.cos(scale(index)) + w
    obj.y = 75 * count * Math.sin(scale(index)) + h
    obj.fill = rand_c()
    obj.r = 25
    x = -> jsonp(obj.title, create)
    setTimeout x, 2000 if index < 1

  nodes = d3.select('.graph').selectAll('.node').data(wiki.query.search)
    .enter().append('circle')
    .on('mouseover', ->
      d3.select(@).attr 'fill-opacity':1, 'stroke-opacity': '.5')
    .on('mouseout', -> d3.select(@).attr 'fill-opacity':.5, 'stroke-opacity':'1')
    .attr
      'fill-opacity': .5
      cx: (d) -> d.x
      cy: (d) -> d.y
      fill: (d) -> d.fill
      stroke: (d) -> d.fill
      'stroke-width': 2
      'stroke-opacity': 1
    .call(drag)
    .transition()
    .duration(1000)
    .ease(d3.ease('cubic-in-out'))
    .delay((d, i) -> i * 50)
    .attr
      r: (d) -> d.r

  nodes.each (d, i) ->
    return 10;
    d3.select('.graph').append('text').datum(d)
      .text(d.title)
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
      if 250 > dist(a, b) and a != b
        links.push
          from: a
          to: b
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
  body.append('input')
    .attr('type','text')
    .style
      background: rand_c
      color: rand_c
    .on 'keydown', (d, i) ->
      if d3.event.which == 13
        jsonp(d3.event.target.value, create)
        d3.event.target.value = ''

  svg = body.append('svg')

  grad = svg.append('linearGradient')
    .attr
      id:'g952'
      gradientUnits: 'userSpaceonUse'
      x1: '0%'
      y1: '0%'
      x2: '100%'
      y2: '100%'
    .selectAll('stop').data(['#fff','#E3A820']).enter().append('stop').attr
      'stop-color': (d) -> d
      offset: (d, i) -> i
  
  grad.append('stop').attr
    'stop-color':'#fff'
    offset: 0

  grad.append('stop').attr
    'stop-color':'#E3A820'
    offset: 1
    
  graph = svg.append('g').attr('class','graph')
  brush = svg.append('g').attr('class','brush')
    .attr
      transform: "translate(0,#{innerHeight * .8})"
      stroke: 'red'
      fill: 'red'
      'stroke-width': '6'
      'stroke-opacity': .6
      'fill-opacity': .5
    .call(d3.svg.brush().x(d3.scale.identity().domain([0, innerWidth])))
    .on('brushstart', -> console.log 'strart')
    .on('brush', -> console.log 'brush')
    .on('brushend', -> console.log 'end')
    .selectAll('rect')
    .attr
      rx: 15
      ry: 15
      height: '100px'

  test = "ocean"
  test && jsonp(test, create)

d3.select(window)
  .on('keydown', -> setInterval rotate, 10 if d3.event.which == 27)
  .on('load', init)
