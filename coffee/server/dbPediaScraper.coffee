request = require 'request'
models = require './models'

isPerson = (data) ->
  data

exports.getJSON = (wikipage, callBack)->
  options = 
    url : "http://dbpedia.org/resource/#{wikipage}"
    headers : "Accept" : "application/json"
  
  request options, (err, res, body)->
    if (err)
      console.log "Error:", err
    data = JSON.parse(body)
    if isPerson(data)
      newPerson = models.makePerson(wikipage, 
        data["http://dbpedia.org/resource/#{wikipage}"]["http://dbpedia.org/ontology/birthDate"][0].value, 
        "http://en.wikipedia.org/#{wikipage}")
      callBack(true, JSON.stringify(newPerson))
    else
      callBack(false)
    



