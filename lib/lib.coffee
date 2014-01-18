http = require 'http'
csv = require 'csv'
async = require 'async'
zip = require 'node-zip'
xml2js = require 'xml2js'
Location = require('./models').Location

Waterdata =
  # RWS open data url
  url: 'http://www.rws.nl/rws/opendata/meetdata/meetdata.zip'

  # Download a zipfile
  getZip: (url, callback) ->
    http.get url, (res) ->
      zipdata = new Buffer(0)
      res.on('data', (data) ->
        zipdata = Buffer.concat([zipdata, data])
      ).on('end', ->
        callback zipdata.toString('binary')
      )

  # Handle zip file. Extracts the two files we need.
  handleZip: (zipStream) ->
    metadataFileName = 'update.adm'
    dataFileName = 'update.dat'
    files = zip zipStream
    metadataFile = files.files[metadataFileName]
    dataFile = files.files[dataFileName]
    return [metadataFile.data, dataFile.data]

  # Convert a csv file to an array of arrays
  csvToArray: (csvString, callback) ->
    csv().from.string(csvString)
      .to.array (data, count) ->
        callback null, data

  # Process the data in the arrays
  readData: (arrays) ->
    res = []
    metadataArray = arrays[0]
    dataArray = arrays[1]
    parameterType = 3
    name = 1
    lastUpdate = 8
    for data, index in dataArray
      metadata = metadataArray[index]
      if metadata[parameterType].trim() == 'H10'
        #callback(metadata[name], parseInt data[lastValue])
        res[res.length] = {lokatie: metadata[name].trim(), waarde:@getLastValue(data), laatstBijgewerkt: metadata[lastUpdate].trim()}
    return res

  # Write the new values to the database for storage
  writeToDb: (object, callback) ->
    Location.update {lokatie:object.lokatie}, object, {upsert: true}, callback

  processWaterdata: (callback) ->
    # get the zipfile
    console.log 'Starting'
    @getZip @url, (zipstream) =>
      console.log 'File received'
      # get the two files we need
      files = @handleZip zipstream
      # get the arrays
      console.log 'Arrays created'
      async.map files, @csvToArray, (error, arrays) =>
        # read the relevant files
        values = @readData arrays
        # store the data in the database
        async.each values, @writeToDb, callback

  getLastValue: (values) ->
    numbers = values.filter (value) ->
      value = value.replace(' ','')
      value.length > 0 and (value >=0 or value < 0)
    return '-' if numbers.length < 1
    parseInt(numbers[numbers.length-1])

Metadata =
  getXml: (url, callback) ->
    http.get url, (res) ->
      xmldata = new Buffer(0)
      res.on 'data', (data) ->
        xmldata = Buffer.concat [xmldata, data]
      .on 'end', ->
        parser = new xml2js.Parser()
        parser.parseString xmldata.toString(), (error, result) ->
          callback result

  update: (location, callback) ->
    Location.findOne {lokatie:location.locatie}, (error, result) ->
      if (result != null)
        result.coordinaten = {}
        result.coordinaten.x = parseFloat location.x
        result.coordinaten.y = parseFloat location.y
        result.omschrijving = location.locatie_omschrijving
        result.save()
      callback()

  process: (callback) ->
    console.log 'Grabbing metadata'
    @getXml @url, (data) =>
      locations = data.nat.waterdata
      async.each locations, @update, (error) ->
        callback()

  url: 'http://rws.nl/system/externen/meetnet-repository.aspx'

exports.Waterdata = Waterdata
exports.Metadata = Metadata
