makeScraper = () ->
  scraper = 
    getRelatedPeople : (person) ->
      @getDBPediaData(person)
    checkIfPerson : (link) ->

    getDBPediaData : (pageTitle) ->
      options = 
        headers : 
          "Access-Control-Allow-Origin": "*"
          "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE"
          "Access-Control-Allow-Headers": "Authorization"
        url : "http://dbpedia.org/resource/#{pageTitle}"
        dataType : "jsonp"
        error : (error) ->
          debugger
          console.log("Error", error)
        success : (data) ->
          console.log("data: ", data)
      $.ajax options
  scraper