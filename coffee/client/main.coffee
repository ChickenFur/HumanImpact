personTest = null

$(document).ready () ->
  $('.nameInput').on "keyup", (event) ->
    if event.keyCode == 13
      settings = 
        url : "/dbpedia/?wikipage=#{event.target.value}" 
        dataType : "json"
        success : (data)->
          if(data.name)
            debugger
            personTest = data
            $(".result").append("<p>Person Name: #{personTest.name}<br>Date of Birth: #{personTest.dob}<br>URL: #{personTest.url}<br>Relations: #{personTest.realtions}</p>")
          else
            debugger
            $(".result").append "<p>Not a Person</p>"
        error : (err)->
          console.log "Error:", err
      
      $.ajax settings
