// Generated by CoffeeScript 1.4.0
(function() {
  var Person, db, mongoose, personSchema, pwd, user;

  mongoose = require('mongoose');

  user = process.env.mongoUser;

  pwd = process.env.mongoPWD;

  console.log("mongodb://" + user + ":" + pwd + "@linus.mongohq.com:10069/humanimpact");

  mongoose.connect("mongodb://" + user + ":" + pwd + "@linus.mongohq.com:10069/humanimpact");

  db = mongoose.connection;

  db.once('open', function() {
    return console.log("Connection Open");
  });

  personSchema = mongoose.Schema({
    name: String,
    url: String,
    dob: String,
    relations: []
  });

  Person = mongoose.model("Person", personSchema);

  exports.addPerson = function(person, callBack) {
    var newPerson;
    newPerson = new Person({
      name: person.name,
      url: person.url,
      dob: person.dob,
      relations: person.relations
    });
    return newPerson.save(function(err) {
      if (err) {
        callBack(err);
      }
      return callBack();
    });
  };

  exports.getPerson = function(personName, callBack) {
    return Person.findOne({
      name: personName
    }, callBack);
  };

}).call(this);
