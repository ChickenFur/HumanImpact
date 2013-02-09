dbPediaScraper = require "./dbPediaScraper"
request = require 'request'
# http request to wikipedia to get links on page

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

# loop through results and check dbPedia to see if each link is a person

#if result is a person, save in for to db and add id to relations

#repeat

