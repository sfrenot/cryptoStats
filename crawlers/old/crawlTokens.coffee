_ = require 'lodash'
Promise = require 'bluebird'
cheerio = require 'cheerio'
cryptos = require '../cryptos.json'
request = require 'request-promise'

# TODO : tester les cas avec crypto qui ont déjà des token
crypto = _.find cryptos, (crypt) ->
  not crypt.forked_data? and
  "Token" in crypt.tags and
  not ("forked_altcoin" in crypt.tags or "forked_bitcoin" in crypt.tags)

console.warn "Token #{JSON.stringify crypto, null, 2}"

request
  url : 'https://coinmarketcap.com'+crypto.url
  method: 'GET'
.then (body) ->
  $ = cheerio.load(body)

#__next > div.sc-1mezg3x-0.fHFmDM.cmc-app-wrapper.cmc-app-wrapper--env-prod.cmc-theme--day > div.container.cmc-main-section > div.cmc-main-section__content > div.aiq2zi-0.jvxWIy.cmc-currencies > div.cmc-currencies__details-panel > ul.sc-1mid60a-0.fGOmSh.cmc-details-panel-links > li.cmc-details-contract-lists > div.cmc-details-contract-lists__container > span
  forked_from =[]
  $('div.cmc-details-contract-lists__container > span').each () ->
    forked_from.push($(@).text())

  bloc = []
  $('span.cmc-details-contract-lists__item').each () ->
    bloc.push($(@).text())

  crypto.forked_data =
    block: bloc
    forked_from: forked_from

.then () ->
  console.warn "Token #{JSON.stringify crypto, null, 2}"
  console.log JSON.stringify cryptos, null, 2
