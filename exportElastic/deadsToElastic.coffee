_ = require 'lodash'
unless process.argv[2]?
  console.warn("usage : coffee cryptosToElastic.coffee <date>")
  process.exit(1)

date = process.argv[2]
raw = require '../files/cryptos-'+date+'.json'
datas = require '../cryptos.json'

ret=''
contracts = _.map (require "../contracts"), "contract"

for crypto in raw.data
  found = datas[crypto.name]
  unless found?
    found = _.find (_.values datas), {"url": "/currencies/#{crypto.slug}"}

  unless found?
    console.warn("#{crypto.name} not found in DB")
  else
    if "Dead" in found.tags
      datadb={}
      datadb["tag_Dead"] = true
      _.forEach found, (val, key) ->
        unless key == "name" or key == "tags" or key == "forked_data" or key=="depends" or key== "people" or key=="deaths"
          datadb[key]=val
        if key == "tags"
          val.forEach (x) ->

            if not x.endsWith('L') or
            x is not 'NoLicenceFile' or
            x is not 'NoGitHub'
              datadb["tag_"+x] = true

            if x in contracts
              datadb["tag_type"] = "Contract"
              datadb["tag_ChainType"] = x.replace(/Contract/, '')

      if datadb.checkedWithGecko?.found
        datadb.checkedWithGecko = true
      else
        datadb.checkedWithGecko = false

      if datadb['tag_sc-assetbacked-unknown']? or
         datadb['tag_sc-assetbacked-fiat-currencies']? or
         datadb['tag_sc-assetbacked-fiat-others']? or
         datadb['tag_sc-assetbacked-collaterized']? or
         datadb['tag_sc-algorithmic']?
        datadb.type = 'Stablecoin'
      else if datadb.tag_type?
        datadb.type = 'Contract'
        delete datadb.tag_type
      else if datadb.tag_Coin?
        delete datadb.tag_Coin
        datadb.type = 'Coin'
      else if datadb.tag_Token?
        delete datadb.tag_Token
        datadb.type = 'Token'
      else
        datadb.type = 'Unkown Type'

      # tags = []
      # if crypto.tags?
      #   tags = crypto.tags.map( (x) -> return "\"tag_api_#{x}\":true" )
      ret+="""{"index":{"_index": "deads"}}\n"""
      ret+="{\"id_coincap\": #{crypto.id},
      \"name\":\"#{crypto.name}\",
      \"symbol\":\"#{crypto.symbol}\",
      \"slug\":\"#{crypto.slug}\","
      # if tags.length > 0
      #   ret+="#{tags},"
      ret+="\"date_data\": \"#{raw.status.timestamp}\",
      \"max_supply\":#{crypto.max_supply},
      \"circulating_supply\":#{crypto.circulating_supply},
      \"total_supply\": #{crypto.total_supply},
      \"last_updated\": \"#{crypto.last_updated}\",
      \"price\": #{crypto.quote.USD.price},
      \"volume_24h\": #{crypto.quote.USD.volume_24h},
      \"market_cap\": #{crypto.quote.USD.market_cap},
      \"usd_last_updated\": \"#{crypto.quote.USD.last_updated}\""
      _.forEach(datadb, (val,key) ->
        unless val == true or val== false
          val="\"#{val}\""
        ret+=",\"#{key}\":#{val}"
      )
      ret+="}\n"

console.log(ret)
