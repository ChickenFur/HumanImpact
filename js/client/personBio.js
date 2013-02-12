// Generated by CoffeeScript 1.4.0
(function() {

  define("personBio", function() {
    var bio, display, formatBio, get;
    bio = null;
    get = function(personName, callBack) {
      var settings;
      settings = {
        url: "http://en.wikipedia.org/w/api.php?action=parse&page=" + personName + "&section=0&format=json",
        dataType: "jsonp",
        success: function(data) {
          bio = formatBio(data.parse.text["*"]);
          return callBack();
        },
        error: function(error) {
          return console.log("Error Getting Bio: ", error);
        }
      };
      return $.ajax(settings);
    };
    display = function(desiredTag) {
      return $(desiredTag).append(bio);
    };
    formatBio = function(bio) {
      bio = bio.slice(bio.indexOf("<p>"), bio.indexOf("<strong"));
      while (bio.indexOf("href=\"/wiki") !== -1) {
        bio = bio.replace("href=\"/wiki", "href=\"http://en.wikipedia.org/wiki");
      }
      return bio;
    };
    return {
      get: get,
      display: display,
      bio: bio
    };
  });

}).call(this);
