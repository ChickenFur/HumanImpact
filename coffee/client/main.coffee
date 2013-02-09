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
      url : "http://en.wikipedia.org/w/api.php?" +
            "format=json&" +
            "action=query&" +
            "titles=#{$(".nameInput").val()}&" +
            "pllimit=300&" +
            "prop=links"

      # http://en.wikipedia.org/w/api.php?action=query&titles=Napoleon&prop=categories&format=json

      dataType : "jsonp"
      success : (data) ->
        debugger
        $(".allLinks").html("")
        pageId = Object.keys(data.query.pages)
        allLinks = data.query.pages[pageId].links
        for i in [0..allLinks.length]
          eachLink = data.query.pages[pageId].links[i].title
          eachLink = eachLink.replace /\s/g, "_" 
          console.log eachLink
          $(".allLinks").append eachLink
      error : (err) ->
        console.log "Error with Wikipedia: ", err

    $.ajax settings




