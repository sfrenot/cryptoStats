_ = require 'lodash'
Promise = require 'bluebird'
cheerio = require 'cheerio'
cryptos = require '../cryptos.json'
request = require 'request-promise'

# TODO : tester les cas avec crypto qui ont déjà des token
cryptoDown = _.find cryptos, (crypt) ->
  if crypt.name.endsWith("DOWN") and not ("BNB" in crypt.tags)
    crypt = crypt.name.split("DOWN")[0]
    console.log(crypt)

process.exit(1)



# unless crypto?
#   console.log JSON.stringify cryptos, null, 2
#   process.exit(1)
#
# request
#   url : 'https://coinmarketcap.com'+crypto.url
#   method: 'GET'
# .then (body) ->
#   $ = cheerio.load(body)
#   url = $('.cmc-details-panel-links > li').each () ->
#     if $(@).text() is 'Website'
#       if $('a', @).attr('href').startsWith("https://ftx.com")
#         crypto.tags.push("Ftx")
#       else
#         console.warn "Raté #{crypto.url}"
#         console.log JSON.stringify cryptos, null, 2
#         process.exit(1)
#
# .then () ->
#   console.warn "Token #{JSON.stringify crypto, null, 2}"
#   console.log JSON.stringify cryptos, null, 2
