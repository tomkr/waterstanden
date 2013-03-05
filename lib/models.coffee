mongoose = require 'mongoose'
#mongoose.connect('localhost', 'waterstanden-test')

schema = mongoose.Schema {
  lokatie: String,
  waarde: Number
}
Location = mongoose.model 'Location', schema
Location.connect = () ->
  mongoose.connect('localhost', 'waterstanden-test')

exports.Location = Location
