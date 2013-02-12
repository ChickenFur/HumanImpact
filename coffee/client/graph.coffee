#todo
# convert links to datajoin
# give node.datum access to links
# make node.onclick integrate with current graph
# use voronoi to highlight closest node
# make main node use same code as relations 
define "graph", ["brush", "utils","require", "getPerson", "initialize_svg"], (brush,  utils, getPerson, require, init) ->
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
      
  update = (scale)->
    nodes = d3.selectAll('.relation')
      # .transition()
      # .duration(1000)
      # .ease(d3.ease('cubic-in-out'))
      .attr
        cx: (d) -> d.x = scale(d.dob)
        
    d3.selectAll('.link').attr
      x1: (d) -> d.from.x
      y1: (d) -> d.from.y
      x2: (d) -> d.to.x
      y2: (d) -> d.to.y

    d3.selectAll('.name').attr
      x: (d) -> d.x
      y: (d) -> d.y
  
  chop = (relations, center) ->
    dist = (i)-> Math.abs(parseInt(center) - i) + Math.random()
    for d in relations
      d.dob = '' + if d.dob.match(/bc/i) then -1 else +1 * parseInt(d.dob)
    if relations.length > 100
      relations.filter((d) -> +d.dob)
      .sort((a,b) -> dist(a.dob) - dist(b.dob))
      .filter((d, i) -> i < relations.length * .5 || +d.dob > 1990)
    else 
        relations
        
  xscale = d3.time.scale()
    .range([15, innerWidth-25])

  create = (wiki) ->
    links = []
    init()
    year = d3.time.format("%Y").parse
    tr = (v) -> xscale(year(v))
    rel = chop(wiki.relations, wiki.dob)
    rel_dates = rel.map((d) -> d.dob)
    min = d3.min rel_dates
    max = d3.max rel_dates
    diff = Math.abs(max) - Math.abs(min)
    k = [min, max].map(year)
    xscale.domain([min, max].map(year))
    brush xscale.copy(), (b) ->
      xscale.domain(if b.empty() then k  else  b.extent())
      update(tr)
    wiki.x = tr(wiki.dob)
    wiki.y = innerHeight / 2
    wiki.links = []
    
    'ocean_fill globe_highlight globe_shading'.split(' ').forEach (d) ->
      d3.select('.graph').datum(wiki).append('circle').attr
        fill: "url(##{d})"
        class: 'main'
        cx: (d) -> d.x
        cy: (d) -> d.y
      .transition().attr r: 50
      
    d3.select('.graph').append('text').text(wiki.name).attr
      fill: 'red'
      x: tr(wiki.dob)
      y: innerHeight / 2
      
    axis = d3.svg.axis()
      .scale(xscale)
      .orient('bottom')
      .ticks(10)

    d3.select('.time')
    .attr('fill','#333')
    .call(axis)
    data = rel.map (data, index) ->
      text: data.name
      i: index
      dob: data.dob
      x: tr(data.dob)
      y: Math.random() * (innerHeight * .9) + 50
      fill: utils.rand_c()
      r: 15
      links: []
      
    nodes = d3.select('.graph').selectAll('.node').data(data)
      .enter().append('circle')
      .on('click', (d)-> require.getPerson(d.text))
      .on('mouseover', (d) ->
        console.log(d)
        d3.select(d.link).attr
          'stroke-opacity': 1
          'stroke-width': 1
        d3.select(d.title[0][0]).attr
          opacity: 1
          'font-size': '1.5em'
          'fill': '#333'
        d3.select(@).transition().duration(4).attr
          'fill-opacity':1
          'r': 25
        )
      .on('mouseout', (d) ->
        d3.select(d.link).transition().attr
          'stroke-opacity': .1
          'stroke-width': 1
        d3.select(d.title[0][0]).attr
          'opacity': .7
          'font-size': '.7em'
          'fill': (d) -> d.fill
        d3.select(@).transition().duration(15).attr
          'fill-opacity':.5
          'r':15
        )
      .attr
        class: 'relation'
        'fill-opacity': .5
        cx: (d) -> d.x = tr(d.dob)
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
      d.title = 
      d3.select('.graph').append('text').datum(d)
        .attr('opacity', .7)
        .text(d.text)
        .transition()
        .duration(1000)
        .delay(i * 50)
        .ease(d3.ease('cubic-in-out'))
        .attr
          'font-size': '.7em'
          class: 'name'
          x: (d) -> d.x - 15
          y: (d) -> d.y + 20
          fill: d.fill
          'font-family': 'deja vu sans mono'

    from = d3.select('.main').datum()
    d3.selectAll('.relation').each (d, i) ->
      if 450 > utils.dist(from, d)
        from.links.push
          from: from
          to: d
          link: @

    d3.select('.graph').selectAll('.link').data(from.links)
      .enter().insert('line', '*')
      .each((d) -> d.to.link = @)
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
        'stroke-opacity': .1
        x2: (d) -> d.to.x
        y2: (d) -> d.to.y

  return {
    create: create
  }
