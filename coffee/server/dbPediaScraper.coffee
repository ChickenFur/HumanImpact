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
    console.log "Body", body
    if isPerson( JSON.parse(body) )
      newPerson = models.makePerson(wikipage, new Date(), "http://en.wikipedia.org/#{wikipage}")
      callBack(true, newPerson)
    else
      callBack(false)
    



