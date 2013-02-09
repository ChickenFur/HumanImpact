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

  $('#checkWiki').on "click", (event) ->
    settings = 
      url : "/wikipedia/?wikipage=#{$(".nameInput").val()}"
      dataType : "json"
      success : (data) ->
        debugger
      error : (err) ->
        console.log "Error with Wikipedia: ", err

    $.ajax settings

