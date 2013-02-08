// Generated by CoffeeScript 1.4.0
(function() {
  var birthDatePropTag, birthDateTag, birthYearTag, isPersonTag, models, rdfSyntaxTag, resourceURL, _convertIfXsd, _findBirthDate, _validateBirth, _validatePerson;

  models = require('./models');

  resourceURL = "http://dbpedia.org/resource/";

  rdfSyntaxTag = "http://www.w3.org/1999/02/22-rdf-syntax-ns#type";

  isPersonTag = "http://dbpedia.org/ontology/Person";

  birthDateTag = "http://dbpedia.org/ontology/birthDate";

  birthDatePropTag = "http://dbpedia.org/property/birthDate";

  birthYearTag = "http://dbpedia.org/ontology/birthYear";

  exports.parse = function(data, wikipage) {
    var birthDate, birthInfo, newPerson, results;
    try {
      data = JSON.parse(data);
      results = _validatePerson(data, wikipage);
      birthInfo = _validateBirth(data, wikipage).year;
      birthInfo = _convertIfXsd(birthInfo);
      if (results.validData) {
        newPerson = models.makePerson(wikipage, birthInfo, "http://en.wikipedia.org/" + wikipage);
        newPerson.data = data;
        return newPerson;
      } else {
        results.data = data;
        return results;
      }
    } catch (error) {
      console.log(error);
      birthDate = _findBirthDate(data);
      newPerson = models.makePerson(wikipage, birthDate, "http://en.wikipedia.org/" + wikipage);
      return newPerson;
    }
  };

  _findBirthDate = function(data) {
    var birthInfoStart;
    birthInfoStart = data.indexOf("\"http://dbpedia.org/property/birthDate");
    data = data.slice(birthInfoStart);
    data = data.slice(data.indexOf("value") + 10);
    data = data.slice(0, data.indexOf("\" ,"));
    return data;
  };

  _convertIfXsd = function(dob) {
    if (dob.length === 25) {
      dob = -(dob.slice(0, 4));
    }
    return dob;
  };

  _validatePerson = function(data, wikipage) {
    var person, results;
    results = {
      validData: true,
      message: ""
    };
    if (!data["" + resourceURL + wikipage]) {
      results.validData = false;
      results.message = "resource URL Bad";
      return results;
    }
    if (!data["" + resourceURL + wikipage][rdfSyntaxTag]) {
      results.validData = false;
      results.message = "rdf Syntax Bad";
      return results;
    }
    if (!data["" + resourceURL + wikipage][rdfSyntaxTag][0]) {
      results.validData = false;
      results.message = "rdf Syntax Array Bad";
      return results;
    }
    if (!data["" + resourceURL + wikipage][rdfSyntaxTag][0].value) {
      results.validData = false;
      results.message = "rdf Syntax Array Value is Bad";
      person = data["" + resourceURL + wikipage][rdfSyntaxTag][0].value;
      if (person !== isPersonTag) {
        results.validData = false;
        results.message = "rdf Syntax Array Value is: " + person;
      }
      return results;
    }
    return results;
  };

  _validateBirth = function(data, wikipage) {
    var results;
    results = {
      validBirth: true,
      year: null,
      message: ""
    };
    try {
      results.year = data["" + resourceURL + wikipage][birthDateTag][0].value;
      results.message = "birthDateTag worked";
    } catch (err) {
      try {
        results.year = data["" + resourceURL + wikipage][birthYearTag][0].value;
        results.message = "birthYearTag worked";
      } catch (err) {
        try {
          results.year = data["" + resourceURL + wikipage][birthDatePropTag][0].value;
          results.message = "birthYearPropTag worked";
        } catch (err) {
          results.validBirth = false;
        }
      }
    }
    return results;
  };

}).call(this);
