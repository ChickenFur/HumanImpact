// Generated by CoffeeScript 1.4.0
(function() {

  define("getPerson", ["findBirth", "graph"], function(findBirth, graph) {
    var getPerson, _checkIfLinksArePeople, _crawlWikipedia, _getDOB, _getLinks, _showResult, _storeRelations,
      _this = this;
    getPerson = function(searchName) {
      var settings;
      settings = {
        url: "/getPerson/?wikipage=" + searchName,
        success: function(data) {
          if (data.name) {
            graph.create(data);
            $("body").addClass("fadedBackground");
          }
          if (data === "Not In DB") {
            return _crawlWikipedia(data, searchName);
          }
        },
        error: function(err) {
          return console.log("Error in Get Person Ajax Request:", err);
        }
      };
      return $.ajax(settings);
    };
    _crawlWikipedia = function(data, searchName) {
      var dob;
      dob = "";
      return _getDOB(searchName, function(birth) {
        dob = birth;
        return _getLinks(searchName, function(links) {
          return _checkIfLinksArePeople(links, function(validLinks) {
            return _storeRelations(searchName, validLinks, dob, function(err) {
              if (err) {
                return console.log("Error Saving Relations To DB:", err);
              }
            });
          });
        });
      });
    };
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
        _results.push(findBirth.findBirthDate(link, links.length - 1, index, function(birth, name, total, index) {
          if (birth !== "Not a Person") {
            peopleLinks.push({
              name: name,
              dob: birth
            });
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
        url: "http://en.wikipedia.org/w/api.php?" + "format=json&" + "action=query&" + ("titles=" + searchName + "&") + "pllimit=500&" + "prop=links",
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
      return findBirth.findBirthDate(name, 0, 0, function(birth) {
        return callBack(birth);
      });
    };
    _showResult = function(name, dob, page, relations) {
      var n, _i, _len, _results;
      $(".result").html("");
      $(".result").append("Name: " + name + "<br>");
      $(".result").append("DOB: " + dob + "<br>");
      $(".result").append("URL: " + page + "<br>");
      $(".result").append("Relations: ");
      _results = [];
      for (_i = 0, _len = relations.length; _i < _len; _i++) {
        n = relations[_i];
        _results.push($(".result").append(" Name: " + n.name + "DOB: " + n.dob));
      }
      return _results;
    };
    return {
      getPerson: getPerson
    };
  });

}).call(this);
