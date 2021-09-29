_ = require 'lodash'
sauve = require './cryptos.json'

tags = []
_.forEach sauve, (elem) ->
  tags = _.concat(tags, elem.tags)

console.log JSON.stringify(_.uniq tags, null, 2)
