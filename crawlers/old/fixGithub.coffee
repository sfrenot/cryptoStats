_ = require 'lodash'
Promise = require 'bluebird'
cheerio = require 'cheerio'
request = require 'request-promise'
cryptos = require '../cryptos.json'
contracts = require '../contracts.json'
licenceName = require '../licences.json'

noLicence = (values, tags) ->
  return (_.findIndex values, (val) -> val in tags) is -1
error = (message...) ->
  console.error "ERROR : ", message
  console.log JSON.stringify cryptos, null, 2
  process.exit(2)

crypto = _.find cryptos, (crypto) ->
  not ("NoGitHubFix" in crypto.tags) and
  "Coin" in crypto.tags and
  not crypto.git?

unless crypto?
  console.error("Crawl Terminé")
  console.log JSON.stringify cryptos, null, 2
  process.exit(1)

request
  url : 'https://coinmarketcap.com'+crypto.url
  method: 'GET'
  headers:
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36'
.then (body) ->
  console.warn "Testing #{crypto.url}"

  $ = cheerio.load(body)

  foundgithub = false
  $('div.guFTCp > div > div > a').each () ->
    if $(@).text() is 'Source code'
      foundgithub = true
      crypto.git = $(@).attr('href')

  unless foundgithub
    crypto.tags.push("NoGitHubFix")

.then () ->
  crypto.tags = _.without crypto.tags, "NoGitHub"
  crypto.tags = _.uniq crypto.tags
  console.log JSON.stringify cryptos, null, 2
.catch (err) ->
  # delete cryptos[crypto.name]
  # error("Crypto #{crypto.name} bugguée")
  crypto.tags.push("NoGitHubFix")
  crypto.tags = _.without crypto.tags, "NoGitHub"
  console.error("Crypto #{crypto.name} bugguée")
  console.log JSON.stringify cryptos, null, 2
