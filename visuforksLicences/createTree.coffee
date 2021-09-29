_ = require "lodash"
cryptos = require "./cryptoLicences.json"
# MAX_CHILDREN = 3

tree =
  name: "root"
  children: []

lvlCrypts = {}

currentCryptos = _.clone cryptos
while not _.isEmpty currentCryptos
  unsolvedCrypt = []
  _.forEach currentCryptos, (crypto) ->
    if crypto.licences.length > 0
      crypto.licences.forEach (crpt) ->
        branch = lvlCrypts[crpt]
        if branch?
          tmpCrypt =
            'name': crypto.name
            'children': []
          branch.children.push tmpCrypt
          lvlCrypts[crypto.name] = tmpCrypt
        else
          unsolvedCrypt = _.uniq (unsolvedCrypt.push crypto)
    else
      if not _.find tree.children, {'name': crypto.name}
        tmpCrypt =
          'name': crypto.name
          'children': []
        tree.children.push tmpCrypt
        lvlCrypts[crypto.name] = tmpCrypt
      else
        console.erreur "Erreur doublon #{crypto}"
        process.exit(1)

  currentCryptos = _.clone unsolvedCrypt
#
# pruneChildren = (array) ->
#   childs = []
#   cpt = 0
#   array.forEach (elem) ->
#     if cpt < MAX_CHILDREN or not _.isEmpty elem.children
#       if not _.isEmpty elem.children
#         elem.children = pruneChildren(elem.children)
#       else
#         cpt++
#       childs.push elem
#   childs
#
# tree.children = pruneChildren(tree.children)

console.log JSON.stringify tree, null, 2
