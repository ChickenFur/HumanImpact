mongoose = require('mongoose');
user = process.env.mongoUser
pwd = process.env.mongoPWD
console.log("mongodb://#{user}:#{pwd}@linus.mongohq.com:10069/humanimpact")
mongoose.connect("mongodb://#{user}:#{pwd}@linus.mongohq.com:10069/humanimpact")
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
  Person.find { name: personName }, callBack