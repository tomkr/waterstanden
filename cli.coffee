flatiron = require 'flatiron'
Waterdata = require('./lib/lib').Waterdata
Metadata = require('./lib/lib').Metadata
Location = require('./lib/models').Location

app = flatiron.app

app.use flatiron.plugins.cli, {}

app.config.env()
app.config.defaults({
  'MONGOHQ_URL': 'mongodb://localhost:27017/waterstanden-dev'
})

Location.connect(app.config.get('MONGOHQ_URL'))

read = ->
  Location.toJson (error, res) -> 
    console.log res
    Location.db.close()

process = ->
  Waterdata.processWaterdata ->
    Location.db.close()

metadata = ->
  Metadata.process ->
    Location.db.close()

app.cmd 'process', process
app.cmd 'read', read
app.cmd 'metadata', metadata
app.start()
