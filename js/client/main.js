// Generated by CoffeeScript 1.4.0
(function() {
  var personTest;

  personTest = null;

  $(document).ready(function() {
    return $('.nameInput').on("keyup", function(event) {
      var settings;
      if (event.keyCode === 13) {
        settings = {
          url: "/dbpedia/?wikipage=" + event.target.value,
          dataType: "json",
          success: function(data) {
            if (data !== "Not a Person") {
              personTest = data;
              return $(".result").append("<p>Person Name: " + personTest.name + "<br>Date of Birth: " + personTest.dob + "<br>URL: " + personTest.url + "<br>Relations: " + personTest.realtions + "</p>");
            } else {
              return $(".result").append("<p>Not a Person</p>");
            }
          },
          error: function(err) {
            debugger;            return console.log("Error:", err);
          }
        };
        return $.ajax(settings);
      }
    });
  });

}).call(this);
