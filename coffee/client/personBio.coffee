define "personBio", () ->
  bio = null
  get = (personName, callBack) ->
    settings = 
      url : "http://en.wikipedia.org/w/api.php?action=parse&page=#{personName}&section=0&format=json" #"http://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&rvsection=0&titles=#{personName}&format=json"
      dataType : "jsonp"
      success : (data) ->
        bio = formatBio data.parse.text["*"]
        callBack()
      error : (error) ->
        console.log "Error Getting Bio: ", error
    $.ajax settings

  display = (desiredTag) ->
    $("#bioText").remove()
    $(desiredTag).append("<div id='bioText'> #{bio} </div>")

  formatBio = (bio)->
    bio = bio.slice( bio.indexOf("<p>"), bio.indexOf("<strong") )
    while ( bio.indexOf( "href=\"/wiki") isnt -1 ) 
      bio = bio.replace("href=\"/wiki", "href=\"http://en.wikipedia.org/wiki")
    bio

  {get : get, display : display, bio : bio}

