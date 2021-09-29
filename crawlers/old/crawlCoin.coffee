_ = require 'lodash'
Promise = require 'bluebird'
cheerio = require 'cheerio'
request = require 'request-promise'
cryptos = require '../cryptos.json'

crypto = _.find cryptos, (crypto) ->
  "NoGitHub" not in crypto.tags and
  not crypto.git? and
  "Coin" in crypto.tags

unless crypto?
  console.error "Crawl Terminé"
  console.log JSON.stringify cryptos, null, 2
  process.exit(1)

request
  url : 'https://coinmarketcap.com'+crypto.url
  method: 'GET'
.then (body) ->

  $ = cheerio.load(body)

  # Garde pour vérifier si la liste des tags à changé
  tmp = _.clone crypto.tags
  $('li.cmc-detail-panel-tags > span').each () ->
    crypto.tags.push($(@).text())
  crypto.tags = _.uniq crypto.tags

  # unless _.isEqual tmp, crypto.tags
  console.warn "#{crypto.name} [#{tmp}] -> [#{crypto.tags}]"

  # Récupération de l'url bitcoin
  $('.cmc-details-panel-links > li').each () ->
    if $(@).text() is 'Source Code'
      href = $('a', @).attr('href')
      if href.startsWith("https://github.com")
        crypto.git = href

  unless crypto.git?
    console.warn "Site non github #{crypto.name} #{crypto.url}"
    crypto.tags.push("NoGitHub")

.catch (err) ->
  console.error "Erreur sur #{crypto.url}"
  crypto.tags.push("NoGitHub")
.then () ->
  console.log JSON.stringify cryptos, null, 2
  # console.log JSON.stringify crypto, null, 2
