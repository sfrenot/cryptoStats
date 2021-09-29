datas = require '../cryptos.json'
fs = require 'fs'

result = {}

extract_data = (keyword, data) ->
  ret =
    'name':keyword
    'children' : []
  for crypto in Object.keys(data)
    if data[crypto].tags.length is 0
      ret.children.push({
        'name': crypto
        'url':data[crypto].url,
        'value':1
      })
      delete data[crypto]

  while Object.keys(data).length>0
    tags={}
    for x in Object.keys(data)
      for tag in data[x].tags
        if tags[tag]?
          tags[tag]=tags[tag]+1
        else
          tags[tag]=1

    console.warn("Element à trier : "+Object.keys(data).length)
    if Object.keys(data).length is 1
      console.warn(Object.entries(data))
    tab_tags = Object.entries(tags).sort( (a,b) -> (b[1]-a[1]))
    kw = tab_tags[0][0]
    console.warn("Elected KW"+kw+"with :"+tab_tags[0][1])
    soustab={}
    for x in Object.keys(data)
      if data[x]["tags"].includes(kw)
        soustab[x]=data[x]
        soustab[x]["tags"].splice(soustab[x]["tags"].indexOf(kw),1)
        delete data[x]
    ret.children.push(extract_data(kw,soustab))
  return ret

jsonformat = extract_data("root",datas)
console.log(JSON.stringify(jsonformat, null,2))
