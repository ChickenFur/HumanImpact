define "getPerson", ["findBirth", "require", "graph"], (findBirth, require, graph) ->  
  getPerson = (searchName )->
    settings =
        url : "/getPerson/?wikipage=#{searchName}" 
        success : (data)->
          #clear old graph
          if(data.name)
            #_showResult(data.name, data.dob, data.url, data.relations)        
            require("graph").create(data)
          if(data is "Not In DB") 
            _showLoadingButton()  
            _crawlWikipedia data, searchName, ()->
              _hideLoadingButton()
              #_showResult(data.name, data.dob, data.url, data.relations)
              require("graph").create(data)
        error : (err)->
          console.log("Error in Get Person Ajax Request:", err)
      $.ajax settings

  _crawlWikipedia = (data, searchName, callBack) ->
    dob = ""
    _getDOB searchName, (birth) ->
      dob = birth
      _getLinks searchName, (links) ->
        _checkIfLinksArePeople links, (validLinks) ->               
          _storeRelations searchName, validLinks, dob, (err) ->                    
            if err
              console.log "Error Saving Relations To DB:", err  
            callBack() 
  _storeRelations = (searchName, validLinks, dob, callBack) ->
      settings = 
        url : "/savePerson/?name=#{searchName}&dob=#{dob}"
        headers :
          relations : JSON.stringify(validLinks)
        success : ()->
          console.log("Relations Stored")
          callBack()
        error : (err) ->
          callBack(err)
      $.ajax settings
  _checkIfLinksArePeople = (links, callBack) =>
    peopleLinks = []
    for link, index in links
      findBirth.findBirthDate link, links.length-1, index, (birth, name, total, index) => 
        if birth isnt "Not a Person"
          peopleLinks.push({name:name, dob:birth})
        if index is total
          callBack(peopleLinks) 
  _getLinks = (searchName, callBack) ->
    settings = 
      url : "http://en.wikipedia.org/w/api.php?" +
            "format=json&" +
            "action=query&" +
            "titles=#{searchName}&" +
            "pllimit=500&" +
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
    findBirth.findBirthDate name, 0, 0, (birth) ->
      callBack(birth)
  _showResult = (name, dob, page, relations) ->
    $(".result").html("")
    $(".result").append("Name: " + name + "<br>")
    $(".result").append("DOB: "+ dob + "<br>")
    $(".result").append("URL: " + page+ "<br>")
    $(".result").append("Relations: ")
    for n in relations
      $(".result").append( " Name: " + n.name + "DOB: " + n.dob) 

  _showLoadingButton = () ->
    $('.result').html("")
    $("#loadingGif").addClass("showLoading")

  _hideLoadingButton = () ->
    $("#loadingGif").addClass("hideLoading").removeClass("showLoading")
    $('.findBirthDate').click()

  return {getPerson: getPerson}
