http = require 'http'

getJSON = (wikipage)->
  url = "http://dbpedia.org/resource/#{wikipage}"
  http.get url, (res){
    console.log("got a response", res)
  }

