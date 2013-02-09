express = require 'express'
dbPedia = require './server/dbPediaScraper'
mongoDB = require './server/mongoDBConnector'

app = express()

app.get '/getPerson', (req, res) ->
  mongoDB.getPerson req.query['wikipage'], (err, mongoResults) ->
    console.log "Mongo Results", mongoResults
    if mongoResults
      res.send mongoResults
    else
      res.send "Not In DB"
app.use '/savePerson', (req, res) ->
  newPerson = 
    name: req.query["name"]
    dob: req.query["dob"]
    url : "http://en.wikipedia.org/#{req.query["name"]}"
    relations: req.query["relations"]
  mongoDB.addPerson newPerson, (error) ->
    res.send "stored in DB, error: " + error

app.use "/", express.static __dirname + '/client'
  
app.listen process.env.PORT
