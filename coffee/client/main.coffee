require ["findBirth"], (findBirth) -> 
  $(document).ready () ->
    $('.nameInput').on "keyup", (event) ->
      if event.keyCode == 13
        $('.findBirthDate').click()

    $('.findBirthDate').on "click", (event) ->
      searchName = $(".nameInput").val()
      settings = 
        url : "/getPerson/?wikipage=#{searchName}" 
        success : (data)->
          if(data.name)
            _showResult(data.name, data.dob, data.url, data.relations)
          if(data is "Not In DB")
            _getAndSendToDB searchName, () ->
              _getLinks searchName, (links) ->
                _checkIfLinksArePeople links, (validLinks) ->
                  _storeRelations searchName, validLinks, (err) ->
                    if err
                      console.log "Error Saving Relations To DB:", err
                 
        error : (err)->
          console.log("Error in Get Person Ajax Request:", err)
      $.ajax settings
  
  _storeRelations = (searchName, validLinks, callBack) ->
    settings = 
      url : "/updatePerson/?name=#{searchName}&relations=validLinks"
      success : ()->
        console.log("Relations Stored")
      error : (err) ->
        callBack(err)
      $.ajax settings

  _checkIfLinksArePeople = (links, callBack) ->
    peopleLinks = []
    for link in links
      findBirth link, (birth) ->
        if birth isnt "Not a Person"
          peopleLinks.push(link)
    callBack(peopleLinks)
  
  _getLinks = (searchName, callBack) ->
    settings = 
      url : "http://en.wikipedia.org/w/api.php?" +
            "format=json&" +
            "action=query&" +
            "titles=#{searchName}&" +
            "pllimit=300&" +
            "prop=links"
      dataType : "jsonp"
      success : (data) ->
        pageId = Object.keys(data.query.pages)
        allLinks = data.query.pages[pageId].links
        resultsArray = []
        for i in [0..allLinks.length]
          resultsArray.push( data.query.pages[pageId].links[i].title.replace /\s/g, "_" )
        callBack(resultsArray)
      error : (err) ->
        console.log "Error with Wikipedia: ", err

    $.ajax settings

  _getAndSendToDB = (name, callBack) ->
    findBirth name, (birth) ->
      settings =
        url : "/savePerson/?name=#{name}&dob=#{birth}&relations=[]"
        success : (data) ->
          _showResult(name, birth, "http://en.wikipedia.org/#{name}", "")
          $(".result").append("Added to DB")
          callBack()
        error : (err) ->
          console.log("Error Getting Date")
      $.ajax settings

  _showResult = (name, dob, page, relations) ->
    $(".result").html("")
    $(".result").append("Name: " + name + "<br>")
    $(".result").append("DOB: "+ dob + "<br>")
    $(".result").append("URL: " + page+ "<br>")
    $(".result").append("Relations: " + relations + "<br>")

