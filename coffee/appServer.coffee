express = require 'express'
dbPedia = require './server/dbPediaScraper'
mongoDB = require './server/mongoDBConnector'

app = express()

app.get '/dbpedia', (req, res) ->
  mongoDB.getPerson req.query['wikipage'], (err, mongoResults) ->
    console.log mongoResults
    if mongoResults
      res.send mongoResults
    else
      dbPedia.getJSON req.query["wikipage"], (data) ->
        mongoDB.addPerson data, () ->
          res.send data
app.use "/", express.static __dirname + '/client'
  
app.listen 3000
console.log "Listening on port 3000"