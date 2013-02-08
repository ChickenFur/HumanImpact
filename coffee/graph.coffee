log = -> window.debug != false && console.log.apply(console, arguments)

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

mirror = (f) ->
  if "function" != typeof f then f = d3.ease.apply(d3, arguments)
  (t) -> if t < .5 then f(2 * t) else f(2 - 2 * t)

rand_c = ->
  '#' + (0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6)

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

distance = (x1, y1, x2, y2) ->
  xd = x1 - x2
  yd = y1 - y2
  Math.sqrt(xd * xd + yd * yd)

dist = (a, b) ->
  xd = a.x - b.x
  yd = a.y - b.y
  Math.sqrt(xd * xd + yd * yd)

scale = d3.scale.linear()
  .domain([0,9])
  .range([0,Math.PI * 2])

links = []
count = 0
create = (wiki) ->
  h = (window.innerHeight / 2)
  w = (window.innerWidth / 2)
  count++
  wiki.query.search.forEach (obj, index) ->
    obj.x = w + 100 * count * Math.cos(scale(index))
    obj.y = h + 100 * count * Math.sin(scale(index))
    x = -> jsonp(obj.title, create)
    setTimeout x, 2000 if index < 1

  nodes = d3.select('svg').selectAll('.node').data(wiki.query.search)
    .enter().append('circle')
    .call(drag)
    .transition()
    .delay((d, i) -> i * 50)
    .attr
      cx: (d) -> d.x
      cy: (d) -> d.y
      fill: rand_c
      r: 25
  nodes.each (d, i) ->
    d3.select('svg').append('text').datum(d)
      .text(d.title)
      .transition()
      .attr
        x: (d) -> d.x
        y: (d) -> d.y
        fill: rand_c
        'font-family': 'Deja Vu Sans Mono'

  q = d3.geom.quadtree(wiki.query.search, innerWidth, innerHeight)
  i = 0
  # d3.selectAll('circle').data().forEach (d, i) ->
  #   q.visit (node, x1, y1, x2, y2) ->
  #     if 200 > distance(x1, y1, x2, y2) and a != b
  #       links.push
  #         from: a
  #         to: b

  d3.selectAll('circle').data().forEach (a) ->
    d3.selectAll('circle').data().forEach (b) ->
      if 200 > dist(a, b) and a != b
        links.push
          from: a
          to: b

  d3.select('svg').selectAll('line').data(links)
    .enter().insert('line', '*')
    .attr
      'stroke-width': 2
      stroke: -> document.body.style.background
      x1: (d) -> d.from.x
      y1: (d) -> d.from.y
      x2: (d) -> d.to.x
      y2: (d) -> d.to.y
    .transition()
    .delay((d, i) -> i * 25)
    .attr
      stroke: rand_c

init = ->
  body = d3.select('body').style background: '#333'
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
  test = "ocean"
  test && jsonp(test, create)

x = 0
rotate = ->
  d3.selectAll('text').attr('rotate', -> x++)

d3.select(window)
  .on('keydown', -> setInterval rotate, 10 if d3.event.which == 27)
  .on('load', init)

