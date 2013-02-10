// Generated by CoffeeScript 1.4.0

require(["findBirth", "graph"], function(findBirth, graph) {
  var getPeople, _checkIfLinksArePeople, _getDOB, _getLinks, _showResult, _storeRelations,
    _this = this;
  getPeople = function(searchName) {
    var settings;
    settings = {
      url: "/getPerson/?wikipage=" + searchName,
      success: function(data) {
        var dob;
        graph.create(data);
        dob = "";
        if (data.name) {
          _showResult(data.name, data.dob, data.url, data.relations);
        }
        if (data === "Not In DB") {
          return _getDOB(searchName, function(birth) {
            dob = birth;
            return _getLinks(searchName, function(links) {
              return _checkIfLinksArePeople(links, function(validLinks) {
                return _storeRelations(searchName, validLinks, dob, function(err) {
                  debugger;                  if (err) {
                    return console.log("Error Saving Relations To DB:", err);
                  }
                });
              });
            });
          });
        }
      },
      error: function(err) {
        return console.log("Error in Get Person Ajax Request:", err);
      }
    };
    return $.ajax(settings);
  };
  $(document).ready(function() {
    $('.nameInput').on("keyup", function(event) {
      if (event.keyCode === 13) {
        return $('.findBirthDate').click();
      }
    });
    return $('.findBirthDate').on("click", function(event) {
      var searchName;
      searchName = $(".nameInput").val();
      return getPeople(searchName);
    });
  });
  _storeRelations = function(searchName, validLinks, dob, callBack) {
    var settings;
    settings = {
      url: "/savePerson/?name=" + searchName + "&dob=" + dob,
      headers: {
        relations: JSON.stringify(validLinks)
      },
      success: function() {
        return console.log("Relations Stored");
      },
      error: function(err) {
        return callBack(err);
      }
    };
    return $.ajax(settings);
  };
  _checkIfLinksArePeople = function(links, callBack) {
    var index, link, peopleLinks, _i, _len, _results;
    peopleLinks = [];
    _results = [];
    for (index = _i = 0, _len = links.length; _i < _len; index = ++_i) {
      link = links[index];
      _results.push(findBirth(link, links.length - 1, index, function(birth, name, total, index) {
        if (birth !== "Not a Person") {
          peopleLinks.push(name);
        }
        if (index === total) {
          return callBack(peopleLinks);
        }
      }));
    }
    return _results;
  };
  _getLinks = function(searchName, callBack) {
    var settings;
    settings = {
      url: "http://en.wikipedia.org/w/api.php?" + "format=json&" + "action=query&" + ("titles=" + searchName + "&") + "pllimit=300&" + "prop=links",
      dataType: "jsonp",
      success: function(data) {
        var allLinks, i, pageId, resultsArray, _i, _len;
        pageId = Object.keys(data.query.pages);
        allLinks = data.query.pages[pageId].links;
        resultsArray = [];
        for (_i = 0, _len = allLinks.length; _i < _len; _i++) {
          i = allLinks[_i];
          resultsArray.push(i.title.replace(/\s/g, "_"));
        }
        return callBack(resultsArray);
      },
      error: function(err) {
        return console.log("Error with Wikipedia: ", err);
      }
    };
    return $.ajax(settings);
  };
  _getDOB = function(name, callBack) {
    return findBirth(name, 0, 0, function(birth) {
      return callBack(birth);
    });
  };
  return _showResult = function(name, dob, page, relations) {
    $(".result").html("");
    $(".result").append("Name: " + name + "<br>");
    $(".result").append("DOB: " + dob + "<br>");
    $(".result").append("URL: " + page + "<br>");
    return $(".result").append("Relations: " + relations + "<br>");
  };
});
