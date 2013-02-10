// Generated by CoffeeScript 1.4.0

define("graph", function() {
  var count, create, dist, drag, init, links, log, mirror, rand_c;
  log = function() {
    return window.debug !== false && console.log.apply(console, arguments);
  };
  dist = function(a, b) {
    var xd, yd;
    xd = a.x - b.x;
    yd = a.y - b.y;
    return Math.sqrt(xd * xd + yd * yd);
  };
  mirror = function(f) {
    if ("function" !== typeof f) {
      f = d3.ease.apply(d3, arguments);
    }
    return function(t) {
      if (t < .5) {
        return f(2 * t);
      } else {
        return f(2 - 2 * t);
      }
    };
  };
  rand_c = function() {
    return '#' + (0x1000000 + (Math.random()) * 0xffffff).toString(16).substr(1, 6);
  };
  drag = d3.behavior.drag().on('drag', function() {
    var dx, dy;
    dx = d3.event.dx;
    dy = d3.event.dy;
    d3.select(this).attr({
      cx: function(d) {
        return d.x += dx;
      },
      cy: function(d) {
        return d.y += dy;
      }
    });
    d3.selectAll('line').attr({
      x1: function(d) {
        return d.from.x;
      },
      y1: function(d) {
        return d.from.y;
      },
      x2: function(d) {
        return d.to.x;
      },
      y2: function(d) {
        return d.to.y;
      }
    });
    return d3.selectAll('text').attr({
      x: function(d) {
        return d.x;
      },
      y: function(d) {
        return d.y;
      }
    });
  });
  dist = function(a, b) {
    var xd, yd;
    xd = a.x - b.x;
    yd = a.y - b.y;
    return Math.sqrt(xd * xd + yd * yd);
  };
  links = [];
  count = 0;
  create = function(wiki) {
    var data, dates, h, max, min, nodes, w, xscale;
    if (!wiki.relations) {
      return;
    }
    dates = wiki.relations.map(function(d) {
      return parseInt(d.dob);
    });
    min = d3.min(dates);
    max = d3.max(dates);
    xscale = d3.scale.pow().domain([1750, 1850]).range([0, innerWidth]);
    if (d3.selectAll('circle')[0].length > 30) {
      return;
    }
    h = window.innerHeight / 2;
    w = window.innerWidth / 2;
    count++;
    if (!wiki.relations) {
      return console.log(wiki);
    }
    data = wiki.relations.map(function(data, index) {
      console.log(data);
      return {
        text: data.name,
        count: count,
        i: index,
        x: xscale(parseInt(data.dob) || 1950),
        y: Math.random() * innerHeight,
        fill: rand_c(),
        r: 15
      };
    });
    nodes = d3.select('.graph').selectAll('.node').data(data).enter().append('circle').on('mouseover', function() {
      return d3.select(this).attr({
        'fill-opacity': 1
      });
    }).on('mouseout', function() {
      return d3.select(this).attr({
        'fill-opacity': .5
      });
    }).attr({
      'fill-opacity': .5,
      cx: function(d) {
        return d.x;
      },
      cy: function(d) {
        return d.y;
      },
      fill: function(d) {
        return d.fill;
      }
    }).call(drag).transition().duration(1000).ease(d3.ease('cubic-in-out')).delay(function(d, i) {
      return i * 50;
    }).attr({
      r: function(d) {
        return d.r;
      }
    });
    d3.selectAll('circle').data().forEach(function(d, i) {
      return d3.select('.graph').append('text').datum(d).text(d.text).transition().ease(d3.ease('cubic-in-out')).attr({
        x: function(d) {
          return d.x - 5;
        },
        y: function(d) {
          return d.y + 30;
        },
        fill: d.fill,
        'font-family': 'deja vu sans mono'
      });
    });
    d3.selectAll('circle').data().forEach(function(a) {
      return;
      return d3.selectAll('circle').data().forEach(function(b) {
        if (250 > dist(a, b) && a !== b) {
          return links.push({
            from: a,
            to: b
          });
        }
      });
    });
    console.log(links);
    return d3.select('.graph').selectAll('line').data(links).enter().insert('line', '*').attr({
      'stroke-width': 2,
      'stroke-opacity': .01,
      x1: function(d) {
        return d.from.x;
      },
      y1: function(d) {
        return d.from.y;
      },
      x2: function(d) {
        return d.from.x;
      },
      y2: function(d) {
        return d.from.y;
      },
      stroke: function(d) {
        return d.from.fill;
      }
    }).transition().duration(5000).ease(d3.ease('cubic')).attr({
      'stroke-opacity': .3,
      x2: function(d) {
        return d.to.x;
      },
      y2: function(d) {
        return d.to.y;
      }
    });
  };
  init = function() {
    var body, brush, grad, graph, svg;
    body = d3.select('body');
    svg = body.append('svg');
    grad = svg.append('linearGradient').attr({
      id: 'g952',
      gradientUnits: 'userSpaceonUse',
      x1: '0%',
      y1: '0%',
      y2: '100%',
      x2: '0%',
      r: '200%'
    }).selectAll('stop').data(['#a7c8d6', '#7089b3']).enter().append('stop').attr({
      'stop-color': function(d) {
        return d;
      },
      offset: function(d, i) {
        return i;
      }
    });
    graph = svg.append('g').attr('class', 'graph');
    return brush = svg.append('g').attr('class', 'brush').attr({
      transform: "translate(0," + (innerHeight * .99) + ")",
      stroke: 'blue`',
      fill: 'url(#g952)',
      'stroke-width': '1'
    }).call(d3.svg.brush().x(d3.scale.identity().domain([0, innerWidth]))).on('brushstart', function() {
      return console.log('strart');
    }).on('brush', function() {
      return console.log('brush');
    }).on('brushend', function() {
      return console.log('end');
    }).selectAll('rect').attr({
      stroke: '#a5b8da',
      rx: '1.5%',
      height: '5%'
    });
  };
  init();
  return {
    create: create
  };
});
