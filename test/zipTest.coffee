Waterdata = require('../lib/lib').Waterdata
Location = require('../lib/models').Location

fs = require 'fs'
path = require 'path'
assert = require 'assert'

describe 'get zip file from rws', ->
  
  it 'should get the zip file', (done) ->
    Waterdata.getZip Waterdata.url, ->
      done()

  it 'should get two files out of the zipfile', (done) ->
    Waterdata.getZip Waterdata.url, (zipstream) ->
      files = Waterdata.handleZip zipstream
      assert.equal files.length, 2
      assert.equal typeof(files[0]), 'string'
      done()
  
describe 'convert csv to array', ->

  it 'should convert one csv to an array', (done) ->
    csv = "1,2,3\n4,5,6"
    Waterdata.csvToArray csv, (error, res) ->
      assert.equal res.length, 2
      assert.equal res[0].length, 3
      assert.equal res[1][1], '5'
      done()

  it 'should be able to convert arrays out of the rws data', (done) ->
    Waterdata.getZip Waterdata.url, (zipstream) ->
      files = Waterdata.handleZip zipstream
      dataFile = files[1]
      Waterdata.csvToArray dataFile, (error, res) ->
        assert.equal typeof(res), 'object'
        done()
