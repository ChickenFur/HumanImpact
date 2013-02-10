// Generated by CoffeeScript 1.4.0
(function() {

  define("findBirth", function() {
    var findBirthDate, _parseBirthDate;
    _parseBirthDate = function(data) {
      var birth, birthLoc, categories, n, _i, _len;
      birth = "";
      if (data.query.pages[Object.keys(data.query.pages)[0]].categories) {
        categories = data.query.pages[Object.keys(data.query.pages)[0]].categories;
        for (_i = 0, _len = categories.length; _i < _len; _i++) {
          n = categories[_i];
          birthLoc = n.title.indexOf("birth");
          if (birthLoc !== -1) {
            birth = n.title.slice(9, birthLoc - 1);
          }
        }
        if (birth === "") {
          birth = "Not a Person";
        }
      } else {
        birth = "Not a Person";
      }
      return birth;
    };
    return findBirthDate = function(name, total, index, callBack) {
      var settings;
      settings = {
        url: "http://en.wikipedia.org/w/api.php?action=query&titles=" + name + "&prop=categories&format=json",
        dataType: "jsonp",
        success: function(data) {
          var birthDate;
          birthDate = _parseBirthDate(data);
          return callBack(birthDate, name, total, index);
        },
        error: function(error) {
          return callBack(error);
        }
      };
      return $.ajax(settings);
    };
  });

}).call(this);