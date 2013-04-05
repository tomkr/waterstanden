Waterstanden
============

Serves up the most recent water heights in the Netherlands based on the official RWS data. But instead of zips with csvs, a simple json protocol will be used.

Because having public data available is awesome, but zipped csvs are not.

## Waterdata

Rijkswaterstaat (RWS) is the Dutch government agency responsible for roads and waterways. They have open data available for the water levels. This is supplied as a zipfile that can be downloaded with a bunch of csv files that contain the waterheights data. Alongside this is an xml with metadata.

In order to serve the data up more easily, this application turns the relevant data into JSON and serves it up, removing the need for unzipping and csv and xml parsing.

## Locations

The locations have the following fields:

* lokatie: The abbreviated location name
* waarde: The last recorded water level
* omschrijving: A description of the location
* coordinaten: An x and y coordinate in WSG84
* laatstBijgewerkt: A silly string representation of the last time the data was updated
