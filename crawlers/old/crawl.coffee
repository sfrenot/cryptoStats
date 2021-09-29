Promise = require 'bluebird'
cheerio = require 'cheerio'

# Choisir la page d'indexation de coinmarketcap
page = Math.floor(Math.random() * 37) + 1
# Exclure la page d'une sous liste
#while page in [1, 3, 7, 8, 16, 17, 18, 19, 20, 21, 22, 23, 24, 31, 36, 37]
while page in []
  page = Math.floor(Math.random() * 37) + 1

# page = 25
request = require('request-promise').defaults
  url: 'https://coinmarketcap.com/'+page
_ = require 'lodash'

sauve = require './cryptos.json'

request()
.then (body) ->
  # console.log body
  $ = cheerio.load(body)

  #__next > div > div.Layout-sc-57oli2-0.sAhSO.cmc-body-wrapper > div:nth-child(1) > div > div.rbayaw-0.jFRIev > div > div > div > div > table > tbody > tr > td.rc-table-cell.nameTHeader___1_bKM.forced_name_font_size___3lG3U.rc-table-cell-fix-left.rc-table-cell-fix-left-last > a > div > div > p
  # #__next > div > div.Layout-sc-57oli2-0.sAhSO.cmc-body-wrapper > div:nth-child(1) > div > div.rbayaw-0.jFRIev > div > div > div > div > table > tbody > tr:nth-child(1) > td.rc-table-cell.nameTHeader___1_bKM.forced_name_font_size___3lG3U.rc-table-cell-fix-left.rc-table-cell-fix-left-last > a
  cryptos = []
  # Tag de la page principale coinmarketcap
  $('div.rbayaw-0.jFRIev > div > div > div > div > table > tbody > tr > td.rc-table-cell.nameTHeader___1_bKM.forced_name_font_size___3lG3U.rc-table-cell-fix-left.rc-table-cell-fix-left-last > a').each () ->
    crypto = {}
    crypto.name = $('div > div > p:nth-child(1)', @).text()
    crypto.short = $('div > div > p:nth-child(2)', @).text()
    crypto.url = $(@).attr('href')
    crypto.tags = []
    cryptos.push crypto

  i = 0
  testCrypto = cryptos.slice(i, 2)
  if testCrypto[0]?
    while sauve[testCrypto[0]?.name]? # Si le premier est connu alors on saute
      unless testCrypto[0]?
        break;
      testCrypto = cryptos.slice(++i, i+3)

  if testCrypto[0]?
    Promise.each testCrypto, (crypto) ->
    # Promise.each (cryptos).slice(1, 3), (crypto) ->
      # unless crypto.url is "/currencies/vox.finance"
      unless sauve[crypto.name]? or crypto.url is "/currencies/vox.finance"
        request
          url : 'https://coinmarketcap.com'+crypto.url
          method: 'GET'
        .then (body) ->
          $ = cheerio.load(body)
          #__next > div.sc-1mezg3x-0.fHFmDM.cmc-app-wrapper.cmc-app-wrapper--env-prod.cmc-theme--day > div.container.cmc-main-section > div.cmc-main-section__content > div.aiq2zi-0.jvxWIy.cmc-currencies > div.cmc-currencies__details-panel > ul.sc-1mid60a-0.fGOmSh.cmc-details-panel-links > li.cmc-detail-panel-tags
          $('li.cmc-detail-panel-tags > span').each () ->
            crypto.tags.push($(@).text())
          console.error "->", crypto
          sauve[crypto.name] = crypto
        # console.log "coucou", crypto.name
        # Promise.resolve()
        .delay(Math.floor(Math.random() * 10000) + 5000)
      else
        if crypto.url is "/currencies/vox.finance"
          console.warn "VOX Finance indexée : #{page}, #{JSON.stringify crypto, null, 2}"
          sauve[crypto.name] = crypto
        console.warn "Déjà indexée : ", crypto.name
        Promise.resolve()
      # else
      #   console.warn "VOX Finance indexée : #{page}, #{JSON.stringify crypto, null, 2}"
      #   Promise.resolve()
  else
    console.warn "Dernière Crypto indexée page #{page}"
    Promise.resolve()
.then () ->
  # # tri du tableau
  ordered = {}
  _(sauve).keys().sort().each (key) ->
    ordered[key] = sauve[key]

  console.log "#{JSON.stringify ordered, null, 2}"
  # console.log sauve
  console.warn "fin"
.catch (err) ->
  console.warn 'ERR', err
.finally () ->
  # spawn("sh", ["-c", "killall java"])
  console.warn "Fin"
