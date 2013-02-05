# log = ->
#   window.debug != false && console.log.apply(console, arguments)
  
# jsonp =  (query, callback) ->
#   window.__cb__ = callback or -> console.log(arguments)
#   url = "http://en.wikipedia.org/w/api.php?
#     action=query&
#     list=search&
#     srprop=size,links&
#     format=json&
#     callback=__cb__&
#     srsearch=" + query 
#   d3.select('head').append('script').attr('src', url) 

# mirror = (f) ->
#   if "function" != typeof f then f = d3.ease.apply(d3, arguments) 
#   (t) -> if t < .5 then f(2 * t) else f(2 - 2 * t) 

# rand_c = ->
#   '#' + (0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6)

# draw = (c) ->
#   c.attr('fill', rand_c)
#     .transition()
#     .duration(-> Math.random() * 2000 + 2000)
#     .ease(mirror('bounce'))
#     .attr('cx', 900)
#     .each('end', draw.bind(null, c))

# drag = d3.behavior.drag().on 'drag', ->
#   dx = d3.event.dx
#   dy = d3.event.dy
#   d3.select(@).attr
#     cx: (d) -> d.x += dx
#     cy: (d) -> d.y += dy
    
#   d3.selectAll('line').attr
#     x1: (d) -> d.from.x 
#     y1: (d) -> d.from.y 
#     x2: (d) -> d.to.x 
#     y2: (d) -> d.to.y
    
#   d3.selectAll('text').attr
#     x: (d) -> d.x 
#     y: (d) -> d.y
    
# distance = (a, b) ->
#   xd = a.x - b.x
#   yd = a.y - a.y
#   Math.sqrt(xd * xd + yd * yd)

# links = []

# create = (wiki) ->
#   wiki.query.search.forEach (obj, index) ->
#     obj.x = Math.random() * window.innerWidth
#     obj.y = Math.random() * window.innerHeight

#   nodes = d3.select('svg').selectAll('.node').data(wiki.query.search)
#     .enter().append('circle')
#     .call(drag)
#     .transition()
#     .attr
#       cx: (d) -> d.x
#       cy: (d, i) -> d.y
#       fill: rand_c
#       r: 25

#   nodes.each (d, i) ->
#     d3.select('svg').append('text').datum(d)
#       .text(d.title)
#       .transition()
#       .attr
#         x: (d) -> d.x
#         y: (d) -> d.y
#         stroke: rand_c
#         'font-family': 'Deja Vu Sans Mono'
#   nodes.each (a) -> #fixme
#     nodes.each (b) ->
#       if 200 > distance(a, b) and a != b
#         links.push from: a, to: b
          
#   d3.select('svg').selectAll('line').data(links)
#     .enter().insert('line', '*')
#     .attr
#       stroke: -> document.body.style.background
#       x1: (d) -> d.from.x
#       y1: (d) -> d.from.y
#       x2: (d) -> d.to.x
#       y2: (d) -> d.to.y
#     .transition()
#     .delay(500)
#     .attr
#       stroke: 'pink'

# init = ->
#   body = d3.select('body').style background: '#333'
#   body.append('input')
#     .attr('type','text')
#     .style
#       background: rand_c
#       color: rand_c
#     .on 'keydown', (d, i) ->
#       if d3.event.which == 13
#         jsonp(d3.event.target.value, create)
#         d3.event.target.value = ''
        
#   c = body.append('svg').append('circle') 
#   c.attr
#     r: 100
#     cx: 123
#     cy: 200
#     opacity: .3
#   draw(c) 
#   test = ""
#   test && jsonp(test, create)
  
# d3.select(window).on('load', init)
# x = 0
# rotate = ->
#   d3.selectAll('text').attr('rotate', -> x++)

# #setInterval rotate, 10