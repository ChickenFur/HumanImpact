request = require 'request'

exports.getJSON = (wikipage)->
  options = 
    url : "http://dbpedia.org/resource/#{wikipage}"
    headers : "Content-type" : "application/json"
  
  request options, (err, res, body)->
    console.log body
    body



