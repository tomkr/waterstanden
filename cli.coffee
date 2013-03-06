flatiron = require 'flatiron'
processWaterdata = require('./lib/lib').processWaterdata
dbToJson = require('./lib/lib').dbToJson
XML = require('./lib/lib').XML
Location = require('./lib/models').Location

app = flatiron.app

app.use flatiron.plugins.cli, {}

app.config.env()
app.config.defaults({
  'MONGOHQ_URL': 'mongodb://localhost:27017/waterstanden-dev'
})

Location.connect(app.config.get('MONGOHQ_URL'))

read = ->
  dbToJson (error, res) -> 
    console.log res
    Location.db.close()

process = ->
  processWaterdata ->
    Location.db.close()

metadata = ->
  XML.process ->
    Location.db.close()

app.cmd 'process', process
app.cmd 'read', read
app.cmd 'metadata', metadata
app.start()
