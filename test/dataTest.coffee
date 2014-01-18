Waterdata = require('../lib/lib').Waterdata
assert = require 'assert'

describe 'handle rws water data', ->

  it 'should get the last value if it is numeric', ->
    result = Waterdata.getLastValue(['0','1','2','3','4','5'])
    assert.equal result, 5

  it 'should return a numeric value if the last one is not', ->
    result = Waterdata.getLastValue(['0','1','2','3','4','f'])
    assert.equal result, 4

  it 'should not return an empty string', ->
    result = Waterdata.getLastValue(['0','1','2','3','4',''])
    assert.equal result, 4

  it 'should return a dash if there is no numeric value', ->
    result = Waterdata.getLastValue(['n','n','n','n','f'])
    assert.equal result, '-'
