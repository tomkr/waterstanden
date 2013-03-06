XML = require('../lib/lib').XML
Location = require('../lib/models').Location
assert = require 'assert'

describe 'get xml file from rws', ->
  
  it 'should get the xml file', (done) ->
    this.timeout 15000
    XML.getXml XML.url, ->
      done()
  