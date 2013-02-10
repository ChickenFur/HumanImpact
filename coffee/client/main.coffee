require ["findBirth", "graph"], (findBirth, graph) ->
  getPeople = (searchName)->
    settings =
        url : "/getPerson/?wikipage=#{searchName}" 
        success : (data)->
          graph.create(data)
          dob = ""
          if(data.name)
            _showResult(data.name, data.dob, data.url, data.relations)
          if(data is "Not In DB")
            _getDOB searchName, (birth) ->
              dob = birth
              _getLinks searchName, (links) ->
                
                _checkIfLinksArePeople links, (validLinks) ->
                  
                  _storeRelations searchName, validLinks, dob, (err) ->
                    debugger;
                    if err
                      console.log "Error Saving Relations To DB:", err
                 
        error : (err)->
          console.log("Error in Get Person Ajax Request:", err)
      $.ajax settings
  $(document).ready () ->
    $('.nameInput').on "keyup", (event) ->
      if event.keyCode == 13
        $('.findBirthDate').click()

    $('.findBirthDate').on "click", (event) ->
      searchName = $(".nameInput").val()
      getPeople(searchName)
  
  _storeRelations = (searchName, validLinks, dob, callBack) ->
    settings = 
      url : "/savePerson/?name=#{searchName}&dob=#{dob}"
      headers :
        relations : JSON.stringify(validLinks)
      success : ()->
        console.log("Relations Stored")
      error : (err) ->
        callBack(err)
    $.ajax settings

  _checkIfLinksArePeople = (links, callBack) =>
    peopleLinks = []
    for link, index in links
      findBirth link, links.length-1, index, (birth, name, total, index) => 
        if birth isnt "Not a Person"
          peopleLinks.push(name)
        if index is total
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
        for i in allLinks
          resultsArray.push( i.title.replace /\s/g, "_" )
        
        callBack(resultsArray)
      error : (err) ->
        console.log "Error with Wikipedia: ", err

    $.ajax settings

  _getDOB= (name, callBack) ->
    findBirth name, 0, 0, (birth) ->
      # settings =
      #   url : "/savePerson/?name=#{name}&dob=#{birth}&relations=[]"
      #   success : (data) ->
      #     _showResult(name, birth, "http://en.wikipedia.org/#{name}", "")
      #     $(".result").append("Added to DB")
      #     callBack()
      #   error : (err) ->
      #     console.log("Error Getting Date")
      # $.ajax settings
      callBack(birth)

  _showResult = (name, dob, page, relations) ->
    $(".result").html("")
    $(".result").append("Name: " + name + "<br>")
    $(".result").append("DOB: "+ dob + "<br>")
    $(".result").append("URL: " + page+ "<br>")
    $(".result").append("Relations: " + relations + "<br>")

