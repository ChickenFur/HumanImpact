request = require 'request'
dbPParser = require './parser'
resourceURL = "http://dbpedia.org/resource/"
exports.getJSON = (wikipage, callBack)->
  options = 
    url : "#{resourceURL}#{wikipage}"
    headers : "Accept" : "application/json"
  request options, (err, res, body)->
    if (err)
      return console.log "Error:", err
    else
      callBack( dbPParser.parse(body, wikipage) )






