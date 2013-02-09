dbPediaScraper = require "./dbPediaScraper"
request = require 'request'

exports.getAllLinks = (wikipage, callBack) ->
  options =
    url : "http://en.wikipedia.org/w/api/php?" +
          "action=query&" +
          "titles=#{wikipage}&" +
          "plimit=300" +
          "prop=links"
  request options, (err, res, body)->
    if (err)
      return console.log "Error:", err
    else
      callBack(body)


