_ = require "lodash"
cryptos = require "../cryptos.json"
licences = require "../licences"
invertLicences = {}

_.forEach cryptos, (crypto) ->
  delete crypto.git
  delete crypto.url
  delete crypto.short
  delete crypto.sawBirth
  delete crypto.forked_data
  delete crypto.deaths
  if "Coin" in crypto.tags and \
    "Dead" not in crypto.tags and \
    "NoLicenceFile" not in crypto.tags and \
    "NoGitHub" not in crypto.tags
    unless crypto.licences?
      crypto.licences = []
    err = 0
    crypto.tags.forEach (tag) ->
      if tag.endsWith("L")
        licenceCrypto = tag.substring(0, tag.length-1)
        unless cryptos[licenceCrypto]?
           err++
           if err > 1
             console.error "Erreur sur #{licenceCrypto} #{JSON.stringify crypto, null, 2}"
             process.exit()
         else
           unless cryptos[licenceCrypto].licences?
             cryptos[licenceCrypto].licences = [licenceCrypto]
             # console.error cryptos[licenceCrypto]
             # process.exit(1)
           crypto.licences.push(licenceCrypto)

  crypto.licences = _.uniq crypto.licences
  if crypto.licences.length is 0
    delete crypto.licences
  delete crypto.tags

res = _.filter cryptos, (crypto) ->
  if crypto.licences?
    crypto.licences = _.without crypto.licences, crypto.name
  crypto.licences?

console.log JSON.stringify res, null, 2
