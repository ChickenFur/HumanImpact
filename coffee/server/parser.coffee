models = require './models'
resourceURL = "http://dbpedia.org/resource/"
rdfSyntaxTag = "http://www.w3.org/1999/02/22-rdf-syntax-ns#type"
isPersonTag = "http://dbpedia.org/ontology/Person"
birthDateTag = "http://dbpedia.org/ontology/birthDate"
birthDatePropTag = "http://dbpedia.org/property/birthDate"
birthYearTag = "http://dbpedia.org/ontology/birthYear"

exports.parse = (data, wikipage) ->
  try
    data = JSON.parse(data)
    results = _validatePerson(data, wikipage)
    birthInfo = _validateBirth(data, wikipage).year  
    birthInfo = _convertIfXsd(birthInfo)  
    if results.validData
      newPerson = models.makePerson(wikipage, birthInfo, 
        "http://en.wikipedia.org/#{wikipage}")
      newPerson.data = data
      return newPerson
    else
      results.data = data
      return results
  catch error
    console.log error
    birthDate = _findBirthDate(data)
    newPerson = models.makePerson(wikipage,
      birthDate,
      "http://en.wikipedia.org/#{wikipage}")
    return newPerson


_findBirthDate = (data) ->
  birthInfoStart = data.indexOf( "\"http://dbpedia.org/property/birthDate" )
  data = data.slice(birthInfoStart)
  data = data.slice(data.indexOf("value") + 10) 
  data = data.slice(0, data.indexOf("\" ,"))

  data

_convertIfXsd = (dob) ->
  if (dob.length is 25)  
    dob = -(dob.slice(0,4))    
  dob


_validatePerson = (data, wikipage) ->
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
    person = data["#{resourceURL}#{wikipage}"][rdfSyntaxTag][0].value
    unless person is isPersonTag
      results.validData = false
      results.message = "rdf Syntax Array Value is: " + person
    return results
  results

_validateBirth = (data, wikipage) ->
  results =
    validBirth : true
    year : null
    message : ""
  try
    results.year = data["#{resourceURL}#{wikipage}"][birthDatePropTag][0].value
    results.message = "birthDateTag worked"
  catch err
    try 
      results.year = data["#{resourceURL}#{wikipage}"][birthDateTag][0].value
      results.message = "birthYearTag worked"
    catch err
      try 
        results.year = data["#{resourceURL}#{wikipage}"][birthYearTag][0].value
        results.message = "birthYearPropTag worked"
      catch err
        results.validBirth = false
  results
 

   




