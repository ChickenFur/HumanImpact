// Generated by CoffeeScript 1.4.0
(function() {
  var dbPediaScraper, request;

  dbPediaScraper = require("./dbPediaScraper");

  request = require('request');

  exports.getAllLinks = function(wikipage, callBack) {
    var options;
    options = {
      url: "http://en.wikipedia.org/w/api/php?" + "action=query&" + ("titles=" + wikipage + "&") + "plimit=300" + "prop=links"
    };
    return request(options, function(err, res, body) {
      if (err) {
        return console.log("Error:", err);
      } else {
        return callBack(body);
      }
    });
  };

}).call(this);
