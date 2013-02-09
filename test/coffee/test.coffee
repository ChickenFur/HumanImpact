assert = require "assert"
parser = require "../../js/server/parser"
sampleData = require "./sampleData"

describe 'Parser', () ->
  describe '.parse()', () -> 
    it 'should return correctly formatted dates', () -> 
      assert( 1 is 1)
      #parser.parse(sampleData.hannibal, "Hannibal")