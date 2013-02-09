require ["findBirth"], (findBirth) -> 
  $(document).ready () ->
    $('.nameInput').on "keyup", (event) ->
      if event.keyCode == 13
        $('.findBirthDate').click()

    $('.findBirthDate').on "click", (event) ->
      settings = 
        url : "/getPerson/?wikipage=#{$(".nameInput").val()}" 
        success : (data)->
          if(data.name)
            _showResult(data.name, data.dob, data.url, data.relations)
          if(data is "Not In DB")
            _getAndSendToDB $(".nameInput").val() 
        error : (err)->
          console.log("Error in Get Person Ajax Request:", err)
      $.ajax settings

  _getAndSendToDB = (name) ->
    findBirth name, (birth) ->
      settings =
        url : "/savePerson/?name=#{name}&dob=#{birth}&relations=[]"
        success : (data) ->
          _showResult(name, birth, "http://en.wikipedia.org/#{name}", "")
          $(".result").append("Added to DB")
        error : (err) ->
          console.log("Error Getting Date")
      $.ajax settings

  _showResult = (name, dob, page, relations) ->
    $(".result").html("")
    $(".result").append("Name: " + name + "<br>")
    $(".result").append("DOB: "+ dob + "<br>")
    $(".result").append("URL: " + page+ "<br>")
    $(".result").append("Relations: " + relations + "<br>")
