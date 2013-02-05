personTest = null

$(document).ready () ->
  $('.nameInput').on "keyup", (event) ->
    if event.keyCode == 13
      settings = 
        url : "/dbpedia/?wikipage=#{event.target.value}" 
        dataType : "json"
        success : (data)->
          personTest = data
          $(".result").append("<p>Person Name: #{personTest.name}<br>Date of Birth: #{personTest.dob}<br>URL: #{personTest.url}<br>Relations: #{personTest.realtions}</p>")

        error : (err)->
          console.log "Error:", err
      
      $.ajax settings
