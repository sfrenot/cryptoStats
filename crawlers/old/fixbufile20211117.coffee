_=require 'lodash'
cryptos=require "../../cryptos"

_.forEach cryptos, (crypto) ->
  if "Dead" in crypto.tags and not crypto.deaths?
    console.warn("Erreu #{JSON.stringify crypto, null, 2}")

  if "Dead" in crypto.tags and crypto.deaths?.length is 1
    crypto.tags = _.without crypto.tags, "Dead"
    delete crypto.deaths

console.log JSON.stringify cryptos, null, 2
process.exit(1)
