_ = require 'lodash'
Promise = require 'bluebird'
request = require 'request-promise'
writeJsonFile = require 'write-json-file'
cryptos = require '../cryptos.json'
licenceName = require '../licences.json'

noLicence = (values, tags) ->
  return (_.findIndex values, (val) -> val in tags) is -1

crypto = _.find cryptos, (crypto) ->
  "NoLicenceFile" not in crypto.tags and
  "Coin" in crypto.tags and
  noLicence((_.values licenceName), crypto.tags) and
  crypto.git?

unless crypto?
  console.error "Crawl Terminé"
  console.log JSON.stringify cryptos, null, 2
  process.exit(1)

console.warn "Recherche : #{crypto.git}"
console.warn "-> #{crypto.name}"

if url.startsWith('https://github')
  url = "https://raw.githubusercontent.com#{crypto.git.replace(/https:\/\/github.com/,"")}/master/COPYING"
else if url.startsWith('https://gitlab')
  url = "#{crypto.git}/-/raw/master/COPYING"
else
  console.error("NON GIT / NON GITHUB")

console.error url
request
  url : url
  method: 'GET'
.then (body) ->
  # console.warn "coucou"
  lines = body.split('\n')
  found = false
  lines.forEach (line) ->
    # console.warn "--#{line}--"
    # Copyright © 2009-2015 The Bitcoin developers
    if line.trim().startsWith('Copyright')
      found = true
      licence = line
      .trim()
      .replace(/.*\d{4} /, '')
      .replace(/The/, '')
      .replace(/Developers|developers/, '')
      .replace(/PPCoin/, "Peercoin")
      .trim()
      # console.warn line
      unless licenceName[licence]?
        console.error "\"#{licence}\": \"#{licence}L\""
        licenceName[licence]="#{licence}L"
        crypto.tags.push(licenceName[licence])
      else
        unless licenceName[licence] in crypto.tags
          console.warn "Ajout licence #{licenceName[licence]} dans #{crypto.name}"
          crypto.tags.push(licenceName[licence])
        else
          console.warn "License indiquée #{licenceName[licence]} dans #{crypto.name}"
  unless found
    crypto.tags.push("NoLicenceInFile")
    crypto.tags.push("NoLicenceFile")
.catch (err) ->
  console.error "Fichier Licence non trouvée #{crypto.name}"
  crypto.tags.push("NoLicenceFile")
.then () -> # Sauvegarde du fichier de licenses trié
  ordered = {}
  _(licenceName).keys().sort().each (key) ->
    ordered[key] = licenceName[key]
  writeJsonFile('../licences.json', ordered)
.then () ->
  console.log JSON.stringify cryptos, null, 2
  # console.log JSON.stringify crypto, null, 2
