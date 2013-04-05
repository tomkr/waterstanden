Metadata = require('../lib/lib').Metadata
Location = require('../lib/models').Location
assert = require 'assert'

describe 'get xml file from rws', ->
  
  it 'should get the xml file', (done) ->
    this.timeout 15000
    Metadata.getXml Metadata.url, ->
      done()
  