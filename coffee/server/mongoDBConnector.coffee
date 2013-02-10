mongoose = require('mongoose');
user = process.env.mongoUser
pwd = process.env.mongoPWD
url = process.env.mongoDBURL
mongoose.connect("mongodb://#{user}:#{pwd}@#{url}")
db = mongoose.connection
db.once 'open', ()->
  console.log "Connection Open"

personSchema = mongoose.Schema
                name: String,
                url: String,
                dob: String,
                relations: []
  
Person = mongoose.model("Person", personSchema)
exports.addPerson = ( person, callBack )->
  newPerson = new Person 
                name: person.name, 
                url: person.url,
                dob: person.dob,
                relations: person.relations
  newPerson.save (err) ->
    if err
      callBack(err)
    callBack()

exports.getPerson = (personName, callBack) ->
  Person.findOne( {name: personName} , callBack )

exports.updatePersonRelations = (name, relations, callBack) ->
  Person.findOneAndUpdate({name:name }, {relations: relations}, callBack), 