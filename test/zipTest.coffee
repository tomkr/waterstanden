getZip = require('../lib/lib').getZip
rwsUrl = require('../lib/lib').url
handleZip = require('../lib/lib').handleZip
processWaterdata = require('../lib/lib').processWaterdata

csvToArray = require('../lib/lib').csvToArray

fs = require 'fs'
path = require 'path'
assert = require 'assert'

describe 'get zip file from rws', ->
  
  it 'should get the zip file', (done) ->
    # this.timeout(10000)
    getZip rwsUrl, ->
      done()

  it 'should get two files out of the zipfile', (done) ->
    getZip rwsUrl, (zipstream) ->
      files = handleZip zipstream
      assert.equal files.length, 2
      assert.equal typeof(files[0]), 'string'
      done()
  
describe 'convert csv to array', ->

  it 'should convert one csv to an array', (done) ->
    csv = "1,2,3\n4,5,6"
    csvToArray csv, (error, res) ->
      assert.equal res.length, 2
      assert.equal res[0].length, 3
      assert.equal res[1][1], '5'
      done()

  it 'should be able to convert arrays out of the rws data', (done) ->
    getZip rwsUrl, (zipstream) ->
      files = handleZip zipstream
      dataFile = files[1]
      csvToArray dataFile, (error, res) ->
        assert.equal typeof(res), 'object'
        done()

describe 'the whole process', ->
  it 'should not time out', () ->
    this.timeout 10000
    processWaterdata