http = require 'http'
csv = require 'csv'
async = require 'async'
zip = require 'node-zip'
Location = require('./models').Location

# RWS open data url
url = 'http://www.rws.nl/rws/opendata/meetdata/meetdata.zip'

# Download a zipfile
getZip = (url, callback) ->
  http.get url, (res) ->
    zipdata = new Buffer(0)
    res.on('data', (data) ->
      zipdata = Buffer.concat([zipdata, data])
    ).on('end', ->
      callback zipdata.toString('binary')
    )

# Handle zip file. Extracts the two files we need.
handleZip = (zipStream) ->
  metadataFileName = 'update.adm'
  dataFileName = 'update.dat'
  files = zip zipStream
  metadataFile = files.files[metadataFileName]
  dataFile = files.files[dataFileName]
  return [metadataFile.data, dataFile.data]

# Convert a csv file to an array of arrays
csvToArray = (csvString, callback) ->
  csv().from.string(csvString)
    .to.array (data, count) ->
      callback null, data

# Process the data in the arrays
readData = (arrays) ->
  res = []
  metadataArray = arrays[0]
  dataArray = arrays[1]
  parameterType = 3
  name = 1
  lastValue = 5
  for data, index in dataArray
    metadata = metadataArray[index]
    if metadata[parameterType].trim() == 'H10'
      #callback(metadata[name], parseInt data[lastValue])
      res[res.length] = {lokatie: metadata[name].trim(), waarde:parseInt data[lastValue]}
  return res

# Write the new values to the database for storage
writeToDb = (object, callback) ->
  Location.update {lokatie:object.lokatie}, object, {upsert: true}, callback

# Turn the database into json. Dynamic for now.
dbToJson = (callback) ->
  Location.connect()
  Location.find (error, res) ->
    callback(error, res)
    Location.db.close()

processWaterdata = () ->
  Location.connect()
  # get the zipfile
  console.log 'Starting'
  getZip url, (zipstream) ->
    console.log 'File received'
    # get the two files we need
    files = handleZip zipstream
    # get the arrays
    console.log 'Arrays created'
    async.map files, csvToArray, (error, arrays) ->
      # read the relevant files
      values = readData arrays
      # store the data in the database
      async.each values, writeToDb, () ->
        Location.db.close()

exports.getZip = getZip
exports.handleZip = handleZip
exports.csvToArray = csvToArray
exports.url = url
exports.processWaterdata = processWaterdata
exports.dbToJson = dbToJson



