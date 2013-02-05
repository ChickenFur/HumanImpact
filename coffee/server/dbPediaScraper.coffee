request = require 'request'

exports.getJSON = (wikipage, callBack)->
  options = 
    url : "http://dbpedia.org/resource/#{wikipage}"
    headers : "Content-type" : "application/json"
  
  request options, (err, res, body)->
    if (err)
      console.log "Error:", err
    console.log "Body", body
    callBack(body)



