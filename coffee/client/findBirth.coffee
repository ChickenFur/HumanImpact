define ['findBirth'], function(findBirth) ->
  findBirthDate = (name, callBack) ->
    settings = 
      url : "http://en.wikipedia.org/w/api.php?action=query&titles=#{name}&prop=categories&format=json"
      dataType : "jsonp"
      success : (data) ->
        birthDate = _parseBirthDate(data)
        callBack(birthDate)    
      error : (error) ->
        callBack(error)

    $.ajax settings

  _parseBirthDate = (data) ->
    birthData = data.indexOf( births )
    if birthData is -1
      return "Not a Person"
    data = data.slice(0, birthData)
    data 