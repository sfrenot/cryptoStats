#!/opt/node-v12.6.0-darwin-x64/bin/coffee

_ = require 'lodash'
fs = (require 'fs').promises
Promise = require 'bluebird'
request = require 'request-promise'
cryptos = require '../cryptos.json'
contracts = require '../contracts.json'

DELAY = 1200

error = (message...) ->
  console.error "  -> ERROR : ", message

idExceptions = [
  '3x-long-sushi-token'
  '3x-short-sushi-token'
  'anchor-protocol'
  'binance-krw'
  'cvcoin'
  'eos'
  'ignis'
  'likecoin' #cosmos
  'ndau' #cosmos
  'ouroboros' #cosmos
  'max-property-group'
  'metaverse-dualchain-network-architecture'
  'oraclechain'
  'pegnet'
  'triipmiles'
  'utrum'
  'zensports'
]
# console.log _.values(cryptos)
Promise.each (_.values(cryptos)), (crypto) ->
  unless crypto.checkedWithGecko?
    console.log "test #{crypto.name}"
    crypto.checkedWithGecko = {}
    request
      url: "https://api.coingecko.com/api/v3/coins/#{crypto.url.replace("/currencies/", "")}?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false"
      json: true
    .then (res) ->
      crypto.checkedWithGecko.found = true
      Promise.delay(DELAY)
      .then () ->
        unless res.id in idExceptions
          # console.log JSON.stringify res, null, 2
          if res.asset_platform_id?
            contract = _.find contracts, {"gecko_asset_platform_id": res.asset_platform_id}
            if contract?
              unless contract.contract in crypto.tags
                crypto.tags = _.without crypto.tags, "Coin"
                crypto.tags.push("Token")
                crypto.tags.push(contract.contract)
                crypto.tags = _.uniq crypto.tags
                unless crypto.forked_data?
                  crypto.forked_data = []
                if res.links?.blockchain_site?[0]?
                  crypto.forked_data.push(res.links.blockchain_site[0])
                console.log "  Ajout Contrat -> #{contract.contract}, #{crypto.name}"
              else
                console.log "  ->", crypto.name, "ok"
            else
              console.log "Other -->", (JSON.stringify crypto,null, 2), res
              process.exit(1)

          fs.writeFile("../cryptos.json", (JSON.stringify cryptos, null, 2))
    .catch (err) ->
      crypto.checkedWithGecko.found = false
      fs.writeFile("../cryptos.json", (JSON.stringify cryptos, null, 2))
      .then () ->
        Promise.delay(DELAY)
      .then () ->
        error("Crypto non trouvée : #{crypto.name}", err.statusCode)
