fs = require "fs"
_=require 'lodash'

dates = [ 20201130,
20201201, 20201203, 20201207, 20201208, 20201209, 20201211,
20201213, 20201214, 20201215, 20201216, 20201217, 20201218, 20210106, 20210112,
20210114, 20210115, 20210118, 20210119, 20210120, 20210121, 20210122, 20210126,
20210127, 20210128, 20210129, 20210201, 20210202, 20210203, 20210204, 20210205,
20210206, 20210208, 20210209, 20210210, 20210211, 20210212, 20210213, 20210214,
20210215, 20210216, 20210217, 20210218, 20210219, 20210220, 20210221, 20210222,
20210223, 20210224, 20210225, 20210226, 20210227, 20210228,
20210301, 20210302, 20210303, 20210304, 20210305,
20210306, 20210307, 20210308, 20210309, 20210310,
20210311, 20210312, 20210313, 20210314, 20210315,
20210316, 20210317, 20210318, 20210319, 20210320,
20210321, 20210322, 20210323, 20210324, 20210325,
20210326, 20210327, 20210328, 20210329, 20210330,
20210331, 20210401, 20210402, 20210403, 20210404
]

datesIni = _.reverse dates.sort()
files = {}
dates.forEach (date) ->
  files[date] = require("../files/cryptos-#{date}.json").data

cryptos=require "../cryptos"
# current=require("../files/cryptos-20210322.json").data
# request = ""

cyclicR = ""
cyclicN = 0
removedR = ""
removedN = 0
neverBornR = ""
neverBornN = 0
regularR = ""
regularN = 0
deadR = ""
deadN = 0

total=0
all=0

_.forEach (_.clone cryptos), (crypto) ->
  dates = _.clone datesIni
  all++
  if "Dead" in crypto.tags
    total++

    last = dates.shift()
    found = _.find files[last], {"slug": "#{crypto.url.replace("/currencies/","")}"}
    cyclic = false
    viewed = 0
    nbZero = 0
    if found? and found.quote.USD.volume_24h > 0
      cyclic = true
      for idx of dates
        found = _.find files[dates[idx]], {"slug": "#{crypto.url.replace("/currencies/","")}"}
        if found?
          viewed++
          if found.quote.USD.volume_24h == 0
            nbZero++
    else
      if not found? #Removed Coin
        removed = true
        for date in dates
          found = _.find files[date], {"slug": "#{crypto.url.replace("/currencies/","")}"}
          if not found?
            nbZero++
          else
            break

      else # Deads
        for date in dates
          found = _.find files[date], {"slug": "#{crypto.url.replace("/currencies/","")}"}
          if found?
            viewed++
            if since?
              if found.quote.USD.volume_24h != 0
                unless regularDeath? ## Check if it falls regularly
                  regularDeath = true

            if found.quote.USD.volume_24h == 0
              nbZero++
              if regularDeath is true
                regularDeath = false
            else
              unless since?
                since = nbZero
            # else
            #   break
        unless since?
          neverBorn = true # La monnaie n'ai jamais eu de transaction

    if cyclic
      cyclicN++
      cyclicR+="name.keyword:\"#{crypto.name}\" or \n"
    else if removed
      # console.log "Removed", crypto.name, " since ", nbZero, " extracts"
      removedN++
      removedR+="name.keyword:\"#{crypto.name}\" or \n"
    else if neverBorn?
      # console.log crypto.name, since, nbZero, viewed
      neverBornN++
      neverBornR+="name.keyword:\"#{crypto.name}\" or \n"
    else if regularDeath? and regularDeath is true
      # console.log crypto.name, since, nbZero, viewed
      regularN++
      regularR+="name.keyword:\"#{crypto.name}\" or \n"
    else
      deadN++
      deadR+="name.keyword:\"#{crypto.name}\" or \n"

console.log "-> Cyclic #{cyclicN} <-"
console.log cyclicR.substring(0, cyclicR.length - (" or ".length))
console.log "-> Removed #{removedN} <-"
console.log removedR.substring(0, removedR.length - (" or ".length))
console.log "-> NeverBorn #{neverBornN} <-"
console.log neverBornR.substring(0, neverBornR.length - (" or ".length))
console.log "-> Natural #{regularN} <-"
console.log regularR.substring(0, regularR.length - (" or ".length))
console.log "-> Dead #{deadN} <-"
console.log deadR.substring(0, deadR.length - (" or ".length))
console.log "Total #{total}/#{all}"
