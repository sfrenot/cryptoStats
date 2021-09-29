fs = require 'fs'
ndjson = require 'ndjson'
data = require './cryptos.json'

tab_data=[]

Object.keys(data).forEach (x) ->
  tab_data.push(data[x])

transformStream = ndjson.stringify();
outputStream = transformStream.pipe( fs.createWriteStream( __dirname + "/data.ndjson" ) )
tab_data.forEach (x) ->
  transformStream.write(x)


transformStream.end();