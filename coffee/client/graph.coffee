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
    if relations.length > 40 
      relations.filter((d) -> +d.dob)
      .sort((a,b) -> dist(a.dob) - dist(b.dob))
      .filter((d, i) -> i < relations.length * .5 || +d.dob > 1990)
        
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
    
    d3.select('.graph')
    .append('circle').attr
      r: 50
      fill: 'url(#ocean_fill)'
      class: 'main'
      cy: innerHeight / 2
      cx: tr(wiki.dob)
      
    d3.select('.graph').append('circle').attr
      r: 50
      fill: 'url(#globe_highlight)'
      class: 'main'
      cy: innerHeight / 2
      cx: tr(wiki.dob)
      
    d3.select('.graph').append('text').text(wiki.name).attr
      fill: 'red'
      x: tr(wiki.dob)
      y: innerHeight / 2
      
    axis = d3.svg.axis()
      .scale(xscale)
      .orient('bottom')
      .ticks(10)

    d3.select('.time').call(axis)
    data = rel.map (data, index) ->
      text: data.name
      i: index
      dob: data.dob
      x: tr(data.dob)
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

  return {
    create: create
  }
