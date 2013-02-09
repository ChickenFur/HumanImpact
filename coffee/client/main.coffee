require ["findBirth"], function(findBirth) -> 

  personTest = null


  $(document).ready () ->
    $('.nameInput').on "keyup", (event) ->
      if event.keyCode == 13
        settings = 
          url : "/dbpedia/?wikipage=#{event.target.value}" 
          dataType : "json"
          success : (data)->
            if(data.name)
              personTest = data
              $(".result").html("")
              $(".result").append("<p>Person Name: #{personTest.name}<br>Date of Birth: #{personTest.dob}<br>URL: #{personTest.url}<br>Relations: #{personTest.relations}</p>")
            else
              $(".result").append "<p>Not a Person</p>"
          error : (err)->
            console.log "Error:", err
        
        $.ajax settings

    $('.findBirthDate').on "click", (event) ->
      findBirth $(".nameInput").val(), (birth) ->
        $(".result").html("")
        $(".result").append(birth)