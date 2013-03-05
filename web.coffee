flatiron = require 'flatiron'
dbToJson = require('./lib/lib').dbToJson
Location = require('./lib/models').Location

app = flatiron.app

app.use flatiron.plugins.http, {}

app.config.env()
app.config.defaults({
  'MONGOHQ_URL': 'mongodb://localhost:27017/waterstanden-dev'
})

Location.connect(app.config.get('MONGOHQ_URL'))

read = ->
  dbToJson (error, json) =>
    Location.db.close()
    @res.writeHead(200, {'Content-Type': 'application/json'})
    @res.write JSON.stringify(json)
    @res.end()

port = process.env.PORT || 5000
app.router.get '/', read
app.listen(port)
