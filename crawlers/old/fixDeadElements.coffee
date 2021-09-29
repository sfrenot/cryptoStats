#grep -H '  "Coin : ' ../files/stat* | cut -d ":" -f 3 | cut -d "]" -f 2 | cut -d "\"" -f 1 |cut -d " " -f 2 |sort|uniq > newCoin

fs = require "fs"
# stdinBuffer = fs.readFileSync(0)
# liste=stdinBuffer.toString().split('\n')
_=require 'lodash'

files = {}

cryptos=require "../cryptos"

_.forEach cryptos, (crypto) ->
  if "Dead" in crypto.tags
    nbDeaths = 0
    unless crypto.deaths? and crypto.url?
      console.log "no deaths", JSON.stringify crypto, null, 2
      process.exit(1)
    unless "01011970" in crypto.deaths
      crypto.deaths.forEach (date) ->
        unless files[date]?
          files[date] = require("../files/cryptos-#{date}.json").data
        found = _.find files[date], {"slug": "#{crypto.url.replace("/currencies/","")}"}
        unless found
          console.log "no found", date, JSON.stringify crypto, null, 2
          process.exit(1)
        if found.quote.USD.volume_24h != 0
          nbDeaths++

      if nbDeaths is crypto.deaths.length
        delete crypto.deaths
        crypto.tags = _.without crypto.tags, "Dead"

console.log JSON.stringify cryptos, null, 2
process.exit(1)

request=""

liste.forEach (elem) ->
  found = _.find (_.values cryptos), {"url": "#{elem}"}
  # unless found?
  #   console.log 'error'
  #   process.exit(1)
  # if found? and (not found.deaths? or not "20210309" in found.deaths) #and not ("Dead" in found.tags)
  if found? and "Dead" in found.tags
    request+="name.keyword:\"#{found.name}\" or "


console.log request.substring(0, request.length - (" or ".length))
