// Generated by CoffeeScript 1.4.0
(function() {
  var findBirthDate, _parseBirthDate;

  findBirthDate = function(name, callBack) {
    var settings;
    settings = {
      url: "http://en.wikipedia.org/w/api.php?action=query&titles=" + name + "&prop=categories&format=json",
      dataType: "jsonp",
      success: function(data) {
        var birthDate;
        birthDate = _parseBirthDate(data);
        return callBack(birthDate);
      },
      error: function(error) {
        return callBack(error);
      }
    };
    return $.ajax(settings);
  };

  _parseBirthDate = function(data) {
    var birthData;
    birthData = data.indexOf(births);
    if (birthData === -1) {
      return "Not a Person";
    }
    data = data.slice(0, birthData);
    return data;
  };

}).call(this);