express = require 'express'
dbPedia = require './server/dbPediaScraper'

app = express()

app.get '/dbpedia', (req, res) ->
  dbPedia.getJSON req.query["wikipage"], (isPerson, body) ->
    res.send body
  
app.listen 3000
console.log "Listening on port 3000"