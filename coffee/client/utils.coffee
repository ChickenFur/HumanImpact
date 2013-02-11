define () ->
  dist: (a, b) ->
    xd = a.x - b.x
    yd = a.y - b.y
    Math.sqrt(xd * xd + yd * yd)

  mirror: (f) ->
    if "function" != typeof f then f = d3.ease.apply(d3, arguments) 
    (t) -> if t < .5 then f(2 * t) else f(2 - 2 * t) 

  rand_c: ->
    '#' + (0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6)

