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


#a.autocomplete({ source: function(request, response) { $.ajax({url:"http://en.wikipedia.org/w/api.php", dataType: "jsonp", data: {'action':"opensearch", 'format': "json", 'search' :request.term }, success: function(data){response(data[1]);}});}});