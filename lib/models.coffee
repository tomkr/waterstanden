mongoose = require 'mongoose'
#mongoose.connect('localhost', 'waterstanden-test')

schema = mongoose.Schema {
  lokatie: String,
  waarde: Number,
  omschrijving: String,
  coordinaten: {
    x: Number,
    y: Number
  }
}
Location = mongoose.model 'Location', schema
Location.connect = (url) ->
  mongoose.connect(url)

exports.Location = Location
