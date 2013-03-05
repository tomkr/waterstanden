Waterstanden
============

Serves up the most recent water heights in the Netherlands based on the official RWS data. But instead of zips with csvs, a simple json protocol will be used.

## How it works

1. Grab the zip file from the RWS server.
2. Extract the zipfile.
3. Match the adm file with the dat file.
4. Filter out everything that's not H10.
5. Load into a database?Write JSON file?

## Why?

Because having public data available is awesome, but zipped csvs are not.
