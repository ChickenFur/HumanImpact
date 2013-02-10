// Generated by CoffeeScript 1.4.0

define("graph", function() {
  var count, create, dist, drag, init, jsonp, links, log, mirror, rand_c, scale, urls;
  console.log(123123);
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
  urls = {
    search: function(q) {
      return "http://en.wikipedia.org/w/api.php?" + "action=query&" + "list=search&" + "srprop=links&" + "format=json&" + "callback=__cb__&" + "srsearch=" + q;
    },
    relevance: function(q) {
      return "action=query&" + "prop=categories&" + "format=json&" + "callback=__cb__&" + "titles=" + query;
    }
  };
  jsonp = function(query, callback) {
    window.__cb__ = callback || function() {
      return log(arguments);
    };
    return d3.select('head').append('script').attr('src', urls.search(query));
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
  scale = d3.scale.linear().domain([0, 9]).range([0, Math.PI * 2]);
  links = [];
  count = 0;
  create = function(wiki) {
    var h, nodes, w;
    if (d3.selectAll('circle')[0].length > 30) {
      return;
    }
    console.log(wiki);
    h = window.innerHeight / 2;
    w = window.innerWidth / 2;
    count++;
    wiki.query.search.forEach(function(obj, index) {
      var x;
      obj.count = count;
      obj.i = index;
      obj.x = 75 * count * Math.cos(scale(index)) + w;
      obj.y = 75 * count * Math.sin(scale(index)) + h;
      obj.fill = rand_c();
      obj.r = 25;
      x = function() {
        return jsonp(obj.title, create);
      };
      if (index < 1) {
        return setTimeout(x, 2000);
      }
    });
    nodes = d3.select('.graph').selectAll('.node').data(wiki.query.search).enter().append('circle').on('mouseover', function() {
      return d3.select(this).attr({
        'fill-opacity': 1,
        'stroke-opacity': '.5'
      });
    }).on('mouseout', function() {
      return d3.select(this).attr({
        'fill-opacity': .5,
        'stroke-opacity': '1'
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
      },
      stroke: function(d) {
        return d.fill;
      },
      'stroke-width': 2,
      'stroke-opacity': 1
    }).call(drag).transition().duration(1000).ease(d3.ease('cubic-in-out')).delay(function(d, i) {
      return i * 50;
    }).attr({
      r: function(d) {
        return d.r;
      }
    });
    nodes.each(function(d, i) {
      return 10;
      return d3.select('.graph').append('text').datum(d).text(d.title).transition().ease(d3.ease('cubic-in-out')).attr({
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
      return d3.selectAll('circle').data().forEach(function(b) {
        if (250 > dist(a, b) && a !== b) {
          return links.push({
            from: a,
            to: b
          });
        }
      });
    });
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
      x2: '100%',
      y2: '100%'
    }).selectAll('stop').data(['#fff', '#E3A820']).enter().append('stop').attr({
      'stop-color': function(d) {
        return d;
      },
      offset: function(d, i) {
        return i;
      }
    });
    grad.append('stop').attr({
      'stop-color': '#fff',
      offset: 0
    });
    grad.append('stop').attr({
      'stop-color': '#E3A820',
      offset: 1
    });
    graph = svg.append('g').attr('class', 'graph');
    return brush = svg.append('g').attr('class', 'brush').attr({
      transform: "translate(0," + (innerHeight * .8) + ")",
      stroke: 'red',
      fill: 'red',
      'stroke-width': '6',
      'stroke-opacity': .6,
      'fill-opacity': .5
    }).call(d3.svg.brush().x(d3.scale.identity().domain([0, innerWidth]))).on('brushstart', function() {
      return console.log('strart');
    }).on('brush', function() {
      return console.log('brush');
    }).on('brushend', function() {
      return console.log('end');
    }).selectAll('rect').attr({
      rx: 15,
      ry: 15,
      height: '100px'
    });
  };
  console.log(12321);
  return init();
});
