#grep -H '  "Coin : ' ../files/stat* | cut -d ":" -f 3 | cut -d "]" -f 2 | cut -d "\"" -f 1 |cut -d " " -f 2 |sort|uniq > newCoin
#grep -H '  "Token : ' ../files/stat* | cut -d ":" -f 3 | cut -d "]" -f 2 | cut -d "\"" -f 1 |cut -d " " -f 2 |sort|uniq > newToken

fs = require "fs"
stdinBuffer = fs.readFileSync(0)
liste=stdinBuffer.toString().split('\n')
_=require 'lodash'

cryptos=require "../cryptos"

request=""

liste.forEach (elem) ->
  found = _.find (_.values cryptos), {"url": "#{elem}"}
  # unless found?
  #   console.log 'error'
  #   process.exit(1)
  # if found? and (not found.deaths? or not "20210309" in found.deaths) #and not ("Dead" in found.tags)
  if found? and not ("Dead" in found.tags)
    request+="name.keyword:\"#{found.name}\" or "


console.log request.substring(0, request.length - (" or ".length))
