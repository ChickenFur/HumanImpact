express = require 'express'
dbPedia = require './server/dbPediaScraper'

app = express()

app.get '/dbpedia', (req, res) ->
  dbPedia.getJSON req.query["wikipage"], (isPerson, body) ->
    if isPerson
      res.send body
    else
      res.send "Not a Person"

app.use "/", express.static __dirname + '/client'
  
app.listen 3000
console.log "Listening on port 3000"