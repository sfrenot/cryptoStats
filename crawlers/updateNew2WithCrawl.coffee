_ = require 'lodash'
Promise = require 'bluebird'
cheerio = require 'cheerio'
request = require 'request-promise'
cryptos = require '../cryptos.json'
contracts = require '../contracts.json'

error = (message...) ->
  console.error "ERROR : ", message
  console.log JSON.stringify cryptos, null, 2
  process.exit(2)

crypto = _.find cryptos, (crypto) -> "New" in crypto.tags
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
  $('div.tagModalTags___3dJxH > div.tagBadge___3p_Pk').each () ->
    crypto.tags.push($(@).text())

  foundgithub = false
  $('div.guFTCp > div > div > a').each () ->
    if $(@).text() is 'Source code'
      foundgithub = true
      crypto.git = $(@).attr('href').replace(/https?:\/\/www.github/,"https://github")
  unless foundgithub
    crypto.tags.push("NoGitHub")

  # token or coin
  foundCoinOrToken = false
  #NameSection
  $('div.kDzKwW > div.bILTHz > div').each () ->
    if $(@).text() is 'Coin'
      foundCoinOrToken = true
      crypto.tags.push($(@).text())
    else if $(@).text() is 'Token'
      foundCoinOrToken = true
      crypto.tags.push($(@).text())
  unless foundCoinOrToken
    error("Type de crypto non trouvé (Coin vs Token) #{crypto.url} #{body}")

  if 'Token' in crypto.tags
    addContract = (href) ->
      contract = _.find contracts, (aContract) ->
        _.find aContract.urls, (url) ->
          href.startsWith(url)

      if contract?
        crypto.tags.push contract.contract
        crypto.forked_data.push href


    # Looking for chain contracts in tags (explorers and contracts)
    foundChain = false
    crypto.forked_data = []
    $('div.guFTCp > div > div').each () ->
      if $('h6', @).text() is 'Explorers'
        $('a', @).each () ->
          addContract($(@).attr('href'))
          foundChain = true

    unless foundChain
      $('div.contractsRow > div.mobileContent___IGuVW > div > a').each () ->
        addContract($(@).attr('href'))
        foundChain = true

    # unless foundChain
    #   error("Type de token inconnu", crypto)

.then () ->
  crypto.tags = _.without crypto.tags, "New"
  crypto.tags.push("New2")
  if "Stablecoin - Asset-Backed" in crypto.tags
    crypto.tags.push("Stablecoin")
  crypto.tags = _.uniq crypto.tags
  console.log JSON.stringify cryptos, null, 2
.catch (err) ->
  # delete cryptos[crypto.name]
  # error("Crypto #{crypto.name} bugguée")
  crypto.tags = _.without crypto.tags, "New"
  console.error("Crypto #{crypto.name} bugguée")
  console.log JSON.stringify cryptos, null, 2
