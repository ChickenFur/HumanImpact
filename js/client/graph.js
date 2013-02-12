// Generated by CoffeeScript 1.4.0

define("graph", ["brush", "utils", "require", "getPerson", "initialize_svg"], function(brush, utils, getPerson, require, init) {
  var chop, create, drag, update, xscale;
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
    d3.selectAll('.link').attr({
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
    return d3.selectAll('.name').attr({
      x: function(d) {
        return d.x;
      },
      y: function(d) {
        return d.y;
      }
    });
  });
  update = function(scale) {
    var nodes;
    nodes = d3.selectAll('.relation').attr({
      cx: function(d) {
        return d.x = scale(d.dob);
      }
    });
    d3.selectAll('.link').attr({
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
    return d3.selectAll('.name').attr({
      x: function(d) {
        return d.x;
      },
      y: function(d) {
        return d.y;
      }
    });
  };
  chop = function(relations, center) {
    var d, dist, _i, _len;
    dist = function(i) {
      return Math.abs(parseInt(center) - i) + Math.random();
    };
    for (_i = 0, _len = relations.length; _i < _len; _i++) {
      d = relations[_i];
      d.dob = '' + (d.dob.match(/bc/i) ? -1 : +1 * parseInt(d.dob));
    }
    if (relations.length > 40) {
      return relations.filter(function(d) {
        return +d.dob;
      }).sort(function(a, b) {
        return dist(a.dob) - dist(b.dob);
      }).filter(function(d, i) {
        return i < relations.length * .5 || +d.dob > 1990;
      });
    }
  };
  xscale = d3.time.scale().range([15, innerWidth - 25]);
  create = function(wiki) {
    var axis, data, diff, k, links, max, min, nodes, rel, rel_dates, tr, year;
    links = [];
    init();
    year = d3.time.format("%Y").parse;
    tr = function(v) {
      return xscale(year(v));
    };
    rel = chop(wiki.relations, wiki.dob);
    rel_dates = rel.map(function(d) {
      return d.dob;
    });
    min = d3.min(rel_dates);
    max = d3.max(rel_dates);
    diff = Math.abs(max) - Math.abs(min);
    k = [min, max].map(year);
    xscale.domain([min, max].map(year));
    brush(xscale.copy(), function(b) {
      xscale.domain(b.empty() ? k : b.extent());
      return update(tr);
    });
    d3.select('.graph').append('circle').attr({
      r: 50,
      fill: 'url(#ocean_fill)',
      "class": 'main',
      cy: innerHeight / 2,
      cx: tr(wiki.dob)
    });
    d3.select('.graph').append('circle').attr({
      r: 50,
      fill: 'url(#globe_highlight)',
      "class": 'main',
      cy: innerHeight / 2,
      cx: tr(wiki.dob)
    });
    d3.select('.graph').append('text').text(wiki.name).attr({
      fill: 'red',
      x: tr(wiki.dob),
      y: innerHeight / 2
    });
    axis = d3.svg.axis().scale(xscale).orient('bottom').ticks(10);
    d3.select('.time').call(axis);
    data = rel.map(function(data, index) {
      return {
        text: data.name,
        i: index,
        dob: data.dob,
        x: tr(data.dob),
        y: Math.random() * innerHeight,
        fill: utils.rand_c(),
        r: 15
      };
    });
    nodes = d3.select('.graph').selectAll('.node').data(data).enter().append('circle').on('click', function(d) {
      return require.getPerson(d.text);
    }).on('mouseover', function() {
      return d3.select(this).attr({
        'fill-opacity': 1
      });
    }).on('mouseout', function() {
      return d3.select(this).attr({
        'fill-opacity': .5
      });
    }).attr({
      "class": 'relation',
      'fill-opacity': .5,
      cx: function(d) {
        return d.x = tr(d.dob);
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
    d3.selectAll('.relation').each(function(d, i) {
      return d3.select('.graph').append('text').datum(d).text(d.text).transition().duration(1000).delay(i * 50).ease(d3.ease('cubic-in-out')).attr({
        "class": 'name',
        x: function(d) {
          return d.x - 5;
        },
        y: function(d) {
          return d.y + 15;
        },
        fill: d.fill,
        'font-family': 'deja vu sans mono'
      });
    });
    d3.selectAll('.relation').data().forEach(function(b) {
      var a;
      a = d3.select('.main');
      a = {
        x: a.attr('cx'),
        y: a.attr('cy')
      };
      if (450 > utils.dist(a, b)) {
        return links.push({
          from: a,
          to: b
        });
      }
    });
    return d3.select('.graph').selectAll('.link').data(links).enter().insert('line', '*').attr({
      'stroke-width': 2,
      'stroke-opacity': .01,
      "class": 'link',
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
        return d.to.fill;
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
  return {
    create: create
  };
});
