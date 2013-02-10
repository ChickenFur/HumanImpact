define "typeAhead",["findBirth"],(findBirth) ->
  attachWikiAutoComplete = (element) ->
    $(element).autocomplete

      source : (request, response) ->
        if request.term.length > 1
          $.ajax
            url: "http://en.wikipedia.org/w/api.php"
            dataType : "jsonp"
            data :
              'action'  : "opensearch"
              'format'  : "json"
              'search'  : request.term
            success : (data) ->
              response(data[1])

  return {attachWikiAutoComplete : attachWikiAutoComplete}



