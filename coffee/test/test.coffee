assert = require('chai').assert
requirejs = require('requirejs')
requirejs.config({nodeRequire: require})

requirejs ['../client/getPerson'], (getPerson) ->
  describe 'getPerson', () ->
    describe 'getPerson.getPerson', () -> 
      getPerson.getPerson "Jesus", ()->
        console.log "The Test Worked"
        #parser.parse(sampleData.hannibal, "Hannibal")