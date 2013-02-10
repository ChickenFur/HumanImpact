define "typeAhead", () ->
  attachWikiAutoComplete = (element) ->
    $(element).autocomplete
      source : (request, response) ->
        url: "http://en.wikipedia.org/w/api.php"
        dataType : "jsonp"
        data :
          'action'  : "opensearch"
          'format'  : "json"
          'search'  : request.term
        success : (data) ->
          response(data[1])


