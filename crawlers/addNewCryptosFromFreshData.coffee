unless process.argv[2]?
  console.warn("usage : coffee addNewCryptosFromFreshData <date(jjmmyyyy)>")
  process.exit(1)

fileDate = process.argv[2]
## ethereum -> ethereum
## defi -> DeFi
## asset-management -> Asset management
## smart-contracts -> Smart Contracts
## staking -> staking
## stablecoin -> Stablecoin
## stablecoin-asset-backed -> Stablecoin - Asset-Backed
tagsTables =
  'adult': 'Adult'
  'agriculture': 'Agriculture'
  'ai-big-data': 'AI & Big Data'
  'algorand-ecosystem': 'Algorand Ecosystem'
  'alameda-research-portfolio':'Alameda Research Portfolio'
  'amm': 'AMM'
  'animoca-brands-portfolio': 'Animoca Brands Portfolio'
  'atomic-swaps':'Atomic Swaps'
  'art': 'Art'
  'arbitrum-ecosytem': 'Arbitrum Ecosytem'
  'asset-backed-coin': 'Asset Backed Coin'
  'asset-management': 'Asset management'
  'aave-tokens': 'Aave Tokens'
  'avalanche-ecosystem': 'Avalanche Ecosystem'
  'bittrex': 'Bittrex'
  'binance': 'Binance'
  'binance-labs-portfolio': 'Binance Labs Portfolio'
  'binance-launchpad': 'Binance Launchpad'
  'binance-launchpool': 'Binance Launchpool'
  'binance-smart-chain': 'Binance Smart Chain'
  'bluezilla': 'Bluezilla'
  'bounce-launchpad': 'Bounce Launchpad'
  'bullperks-launchpad': 'Bullperks Launchpad'
  'centralized-exchange': 'Centralized exchange'
  'chiliz': 'Chiliz'
  'chromia-ecosystem': 'Chromia Ecosystem'
  'cms-holdings-portfolio': 'Cms Holdings Portfolio'
  'coinbase-ventures-portfolio': 'Coinbase Ventures Portfolio'
  'collectibles-nfts': 'Collectibles & NFTs'
  'commodities': 'Commodities'
  'communications-social-media': 'Communications & Social Media'
  'content-creation':'Content Creation'
  'cosmos-ecosystem': 'Cosmos Ecosystem'
  'crowdfunding': 'Crowdfunding'
  'cybersecurity': 'Cybersecurity'
  'dag': 'Dag'
  'dao': 'Dao'
  'dao-maker': 'DAO Maker'
  'dao-maker-launchpad': 'Dao Maker Launchpad'
  'dapp': 'DApp'
  'dcg-portfolio': 'Dcg Portfolio'
  'data-availability-proof': 'Data Availability Proof'
  'decentralized-exchange': 'Decentralized exchange'
  'defi': 'DeFi'
  'defi-index': 'DeFi Index'
  'defiance-capital': 'Defiance Capital'
  'derivatives': 'Derivatives'
  'dex': 'Dex'
  'discount-token': 'Discount token'
  'distributed-computing': 'Distributed Computing'
  'doggone-doggerel': 'Doggone Doggerel'
  'dot-ecosystem': 'DOT Ecosystem'
  'dpos': 'DPoS'
  'dragonfly-capital-portfolio': 'DragonFly Capital Portfolio'
  'duckstarter': 'DuckSTARTER'
  'e-commerce': 'E-commerce'
  'energy': 'Energy'
  'enterprise-solutions':'Enterprise solutions'
  'entertainment': 'Entertainment'
  'eth-2-0-staking':'ETH 2.0 Staking'
  'ethereum': 'Ethereum'
  'ethereum-ecosystem': 'Ethereum Ecosystem'
  'events': 'Events'
  'exnetwork-capital-portfolio': 'Exnetwork Capital Portfolio'
  'fan-token': 'Fan token'
  'fantom-ecosystem': 'Fantom Ecosystem'
  'fenbushi-capital-portfolio': 'Fenbushi Capital Portfolio'
  'filesharing': 'Filesharing'
  'food-beverage': 'Food & Beverage'
  'ftx': 'Ftx'
  'gambling': 'Gambling'
  'gaming': 'Gaming'
  'genpad': 'Genpad'
  'governance': 'Governance'
  'groestl': 'Groestl'
  'hacken-foundation': 'Hacken Foundation'
  'hardware': 'Hardware'
  'hashkey-capital-portfolio': 'Hashkey Capital Portfolio'
  'health': 'Health'
  'heco': 'Heco'
  'heco-ecosystem': 'Heco Ecosystem'
  'hospitality': 'Hospitality'
  'hybrid-pow-pos': 'Hybrid - PoW & PoS'
  'icetea-labs': 'Icetea Labs'
  'identity': 'Identity'
  'insurance': 'Insurance'
  'interoperability': 'Interoperability'
  'iot': 'IoT'
  'jobs': 'Jobs'
  'kinetic-capital': 'Kinetic Capital'
  'launchpad':  'Launchpad'
  'launchzone': 'Launchzone'
  'lending-borowing': 'Lending Borowing'
  'logistics': 'Logistics'
  'loyalty': 'Loyalty'
  'lp-tokens': 'Lp Tokens'
  'marketplace': 'Marketplace'
  'marketing': 'Marketing'
  'masternodes': 'Masternodes'
  'medium-of-exchange': 'Medium of Exchange'
  'media': 'Media'
  'memes': 'Memes'
  'metaverse': 'Metaverse'
  'mineable': 'Mineable'
  'mirror': 'Mirror'
  'mobile': 'Mobile'
  'multicoin-capital-portfolio': 'MultiCoin Capital Portfolio'
  'music': 'Music'
  'mvb': 'Mvb'
  'nftb-launchpad': 'Nftb Launchpad'
  'options': 'Options'
  'oracles': 'Oracles'
  'pantera-capital-portfolio': 'Pantera Capital Portfolio'
  'parafi-capital': 'ParaFi capital'
  'payments': 'Payments'
  'petrock-capital': 'PetRock Capital'
  'philanthropy': 'Philanthropy'
  'platform': 'Platform'
  'platform-token': 'Platform Token'
  'play-to-earn': 'Play to Earn'
  'polygon-ecosystem': 'Polygon Ecosystem'
  'polychain-capital-portfolio': 'Polychain Capital Portfolio'
  'polkadot': 'Polkadot'
  'polkastarter': 'Polkastarter'
  'polkadot-ecosystem': 'Polkadot Ecosystem'
  'polkafoundry-red-kite': 'PolkaFoundry Red Kite'
  'poolz-finance': 'Poolz Finance'
  'pos': 'PoS'
  'pos-30': 'POS 3.0'
  'pow': 'PoW'
  'prediction-markets': 'Prediction Markets'
  'privacy': 'Privacy'
  'quantum-resistant': 'Quantum-Resistant'
  'real-estate': 'Real Estate'
  'rebase': 'Rebase'
  'reputation': 'Reputation'
  'scaling': 'Scaling'
  'scrypt': 'Script'
  'seigniorage': 'Seigniorage'
  'services': 'Services'
  'sharding': 'Sharding'
  'smart-contracts': 'Smart Contracts'
  'social-money': 'Social Money'
  'social-token': 'Social Token'
  'solana-ecosystem': 'Solana Ecosystem'
  'sports': 'Sports'
  'stablecoin': 'Stablecoin'
  'stablecoin-algorithmically-stabilized': 'sc-algorithmic'
  'sc-assetbacked-unknown': 'sc-assetbacked-unknown'
  'sc-assetbacked-fiat-currencies': 'sc-assetbacked-fiat-currencies'
  'sc-assetbacked-fiat-others': 'sc-assetbacked-fiat-others'
  'sc-assetbacked-collaterized': 'sc-assetbacked-collaterized'
  'sc-algorithmic': 'sc-algorithmic'
  'stablecoin-asset-backed': 'sc-assetbacked-needCheck'
  'tokenized-stock': 'Tokenized Stock'
  'staking': 'Staking'
  'state-channels': 'State channels'
  'storage': 'Storage'
  'store-of-value': 'Store of Value'
  'substrate': 'Substrate'
  'superstarter': 'Superstarter'
  'synthetic': 'Synthetic'
  'synthetics': 'Synthetic'
  'technology': 'Technology'
  'terra-ecosystem': 'Terra Ecosystem'
  'tezos-ecosystem': 'Tezos Ecosystem'
  'three-arrows-capital-portfolio': 'Three Arrows Capital Portfolio'
  'token': 'Token'
  'tourism': 'Tourism'
  'tron': 'Tron'
  'trustswap-launchpad': 'trustswap Launchpad'
  'video': 'Video'
  'vr-ar': 'VR/AR'
  'wallet': 'Wallet'
  'web3': 'Web3'
  'wrapped-tokens': 'Wrapped Tokens'
  'x11': 'X11'
  'x13': 'X13'
  'yearn-partnerships': 'Yearn Partnerships'
  'yield-farming': 'Yield farming'
  'yield-aggregator': 'Yield Aggregator'
  'zero-knowledge-proofs': 'Zero Knowledge Proofs'
  'zilliqa-ecosystem': 'Zilliqa Ecosystem'

_ = require 'lodash'
cryptos = require '../cryptos'
fresh = require "../files/cryptos-#{fileDate}"

newCryptos = 1
oldDeadCryptos = 1
newDeadCryptos = 1

# Remove New keyword from old insert
_.forEach cryptos, (crypto) ->
  crypto.tags = _.without crypto.tags, "New2"

  unless "Dead" in crypto.tags
    unless _.find fresh.data, {"name": crypto.name}
      if "External" not in crypto.tags
        console.error("Monnaie supprimée du fichier #{crypto.name} #{crypto.short} #{crypto.url}")
        # process.exit(1)
        crypto.tags.push("Dead")
        crypto.deaths = ["01011970"]

_.forEach fresh.data, (crypto) ->
  if crypto.name.endsWith("FTX")
    crypto.tags.push("ftx")
  if crypto.name.endsWith("Bittrex")
    crypto.tags.push("bittrex")
  if crypto.name.startsWith("Mirrored")
    crypto.tags.push("mirror")
  if crypto.name.endsWith("DOWN")
    crypto.tags.push("binance")
  if crypto.name.endsWith("UP")
    crypto.tags.push("binance")

  unless cryptos[crypto.name]?
    found = _.find (_.values cryptos), {"url": "/currencies/#{crypto.slug}"}
    if found
      console.error "ERREUR : 000 - Renommage #{JSON.stringify found.name, null, 2} -> #{JSON.stringify crypto.name, null, 2}"
      console.log JSON.stringify ordered, null, 2
      process.exit(1)

    console.error "#{newCryptos++} - New #{JSON.stringify crypto.name, null, 2}"
    tmpTags = crypto.tags.map (tag) ->
      unless tagsTables[tag]
        console.error "ERREUR : Tag '#{tag}' inconnu"
        console.log JSON.stringify ordered, null, 2
        process.exit(1)
      tagsTables[tag]
    cryptos[crypto.name] =
      "name": crypto.name
      "short": crypto.symbol
      "url": "/currencies/#{crypto.slug}"
      "tags": ["New"].concat(tmpTags)
      "sawBirth": fileDate

  if crypto.quote.USD.volume_24h is 0 #or crypto.quote.USD.market_cap is 0
    oldDeadCryptos++
    unless cryptos[crypto.name].deaths?
      cryptos[crypto.name].deaths = []
    cryptos[crypto.name].deaths.push(fileDate)
    if "Dead" not in cryptos[crypto.name].tags
      console.error "#{newDeadCryptos++}/#{oldDeadCryptos} - Dead #{JSON.stringify cryptos[crypto.name].name, null, 2}"
      cryptos[crypto.name].tags.push("Dead")

ordered = {}
_(cryptos).keys().sort().each (key) ->
  ordered[key] = cryptos[key]

console.error "FINI - OK"
console.log JSON.stringify ordered, null, 2
