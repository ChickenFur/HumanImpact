models = require './models'
resourceURL = "http://dbpedia.org/resource/"
rdfSyntaxTag = "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
isPersonTag = "http://dbpedia.org/ontology/Person"
birthDateTag = "http://dbpedia.org/ontology/birthDate"

exports.parse = (data, wikipage) ->
  data = JSON.parse(data)
  results = _validate(data, wikipage)
  console.log results.message
  if results.validData and _isPerson(data, wikipage)
    newPerson = models.makePerson(wikipage, 
      data["#{resourceURL}#{wikipage}"][birthDateTag][0].value, 
      "http://en.wikipedia.org/#{wikipage}")
    return newPerson
  else
    return false

_validate = (data, wikipage) ->
  results = 
    validData : true
    message: ""
  unless data["#{resourceURL}#{wikipage}"]
    results.validData = false
    results.message = "resource URL Bad"
    return results
  unless data["#{resourceURL}#{wikipage}"][rdfSyntaxTag]
    results.validData = false
    results.message = "rdf Syntax Bad"
    return results
  unless data["#{resourceURL}#{wikipage}"][rdfSyntaxTag][0]
    results.validData = false
    results.message = "rdf Syntax Array Bad"
    return results
  unless data["#{resourceURL}#{wikipage}"][rdfSyntaxTag][0].value
    results.validData = false
    results.message = "rdf Syntax Array Value is Bad"
    return results
  unless data["#{resourceURL}#{wikipage}"][birthDateTag]
    results.validData = false
    results.message = "Birth Tag is Bad"
    return results
  unless data["#{resourceURL}#{wikipage}"][birthDateTag][0]
    results.validData = false
    results.message = "Birth Tag Array is Bad"
    return results
  unless data["#{resourceURL}#{wikipage}"][birthDateTag][0].value
    results.validData = false
    results.message = "Birth Tag Array [0].value is Bad"
    return results
  results


_isPerson = (data, wikipage) ->
  if data["#{resourceURL}#{wikipage}"][rdfSyntaxTag][0].value is isPersonTag
    return true
    console.log("#{wikipage} is a Person") 
  else
    console.log("#{wikipage} is NOT a Person")
    return false



