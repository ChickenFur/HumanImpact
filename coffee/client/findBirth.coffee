define "findBirth", () ->
  _parseBirthDate = (data) ->
    birth = ""
    if data.query.pages[Object.keys(data.query.pages)[0]].categories
      categories = data.query.pages[Object.keys(data.query.pages)[0]].categories
      for n in categories
        birthLoc = n.title.indexOf ("birth")
        unless birthLoc is -1
          if n.title.indexOf("Year of") is -1            
            birth = n.title.slice(9, birthLoc-1)
          else
            birth = "unknown"
      if birth is ""
        birth = "Not a Person"
    else
      birth = "Not a Person"
    birth

  findBirthDate = (name, total, index, callBack) ->
    settings = 
      url : "http://en.wikipedia.org/w/api.php?action=query&titles=#{name}&prop=categories&format=json"
      dataType : "jsonp"
      success : (data) ->   
        birthDate = _parseBirthDate(data)
        callBack(birthDate, name, total, index)    
      error : (error) ->
        callBack(error)
    $.ajax settings

  return { findBirthDate: findBirthDate }