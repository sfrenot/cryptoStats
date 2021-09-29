unless process.argv[2]?
  console.warn("usage : coffee ./statistics.coffee <date(yyyymmdd)>")
  process.exit(1)

currentDate = process.argv[2]

_ = require 'lodash'
cryptos = require '../cryptos.json'
contracts = require '../contracts.json'
contracts.forEach (contract) ->
  contract.nb = 0
  delete contract.urls

displayContract = () ->
  rep = ""
  contracts.forEach (contract) ->
    if contract.nb > 0
      rep = rep.concat("#{contract.contract}: #{contract.nb}, ")
  rep.substring(0, rep.length-2)

all = 0
token = 0
coin = 0

result = []

allDead = 0
dead = []

_.forEach cryptos, (crypt) ->
  # console.log "-> #{crypt.name}"
  if "New2" in crypt.tags
    all++
    if "Token" in crypt.tags
      token++
      contracts.forEach (contract) ->
        if contract.contract in crypt.tags
          contract.nb++
    else
      unless "Coin" in crypt.tags
        console.error "Erreur sur #{JSON.stringify crypt}"
        process.exit(1)
      coin++
      result.push "Coin : #{crypt.name} [#{crypt.tags}] #{crypt.url}"
  if "Dead" in crypt.tags and crypt.url?
    allDead++
    dead.push "#{crypt.name} [#{crypt.tags}] #{crypt.url}"

console.log "--------- News"
console.log "#{all} nouvelles, dont : #{token} token (dont #{displayContract()})"
console.log "#{result.length} à observer"
console.log "#{JSON.stringify result.sort(), null, 2}"
console.log "--------- "
console.log "#{allDead} mortes, dont #{dead.length} à cette date"
console.log "#{JSON.stringify dead.sort(), null, 2}"
