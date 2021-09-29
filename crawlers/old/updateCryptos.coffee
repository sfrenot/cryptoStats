_ = require 'lodash'
cryptos = require '../cryptos.json'

# _.forEach cryptos, (crypt) ->
#   if crypt.forked_data?.forked_from?
#     crypt.tags = _.uniq crypt.tags.concat(crypt.forked_data.forked_from)
#
# console.log JSON.stringify cryptos, null, 2

_.forEach cryptos, (crypt) ->

  if "30/11/2020" in crypt.tags
    unless crypt.deaths?
      if "Dead" in crypt.tags
        crypt.deaths = ["30112020"]

    else if crypt.deaths[1] isnt "01122020"
      crypt.deaths.splice(0,0,"30112020")

    crypt.tags = _.without crypt.tags, "30/11/2020"

  if _.isEmpty(crypt.deaths)
    delete crypt.deaths

console.log JSON.stringify cryptos, null, 2
