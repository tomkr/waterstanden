flatiron = require 'flatiron'
processWaterdata = require('./lib/lib').processWaterdata
dbToJson = require('./lib/lib').dbToJson

app = flatiron.app

read  = () ->
  dbToJson (error, res) -> 
    console.log res

app.use flatiron.plugins.cli, {}

app.cmd 'process', processWaterdata
app.cmd 'read', read
app.start()
