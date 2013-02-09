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
  $('.wikipedia').on "click", (event) ->
    settings = 
      url : :"http://en.wikipedia.org/w/api.php?"