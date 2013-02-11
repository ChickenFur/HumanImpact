express = require 'express'
mongoDB = require './server/mongoDBConnector'

app = express()

app.get '/getPerson', (req, res) ->
  mongoDB.getPerson req.query['wikipage'], (err, mongoResults) ->
    if mongoResults
      res.send mongoResults
    else
      res.send "Not In DB"

app.use "/updatePerson", (req, res) ->
  relations = JSON.parse req.headers.relations
  mongoDB.updatePersonRelations req.query['name'], relations () ->
    console.log "Added Relations to db"

app.use '/savePerson', (req, res) ->
  newPerson = 
    name: req.query["name"]
    dob: req.query["dob"]
    url : "http://en.wikipedia.org/wiki/#{req.query["name"]}"
    relations: relations = JSON.parse req.headers.relations
  mongoDB.addPerson newPerson, (error) ->
    res.send "stored in DB, error: " + error

app.use "/", express.static __dirname + '/client'

app.get '/wikipedia', (req, res) ->
  personFinder.getAllLinks req.query['wikipage'], (err, data) ->
    res.send data
 
app.listen process.env.PORT
