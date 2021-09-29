let datas = require("./cryptos.json")
const fs = require('fs')

result = {}

function extract_data(keyword, data){
    const ret = {"name" : keyword,
    "children" :[]}
    Object.keys(data).forEach(crypto => {
        if (data[crypto].short==="AST") console.log("Bug reached:"+data[crypto].tags.length)
       if (data[crypto].tags.length === 0){
           ret.children.push({"name":crypto,"value":100})
           delete data[crypto]
       }
    })
    while(Object.keys(data).length>0){
        const tags={}
        Object.keys(data).forEach((x)=>{
            data[x].tags.forEach(tag => {
                if(tag in tags){
                    tags[tag]+=1
                }else{
                    tags[tag]=1
                }
            })
        })
        console.log("Element à trier : "+Object.keys(data).length)
        if(Object.keys(data).length===1) console.log(Object.entries(data))
        const tab_tags = Object.entries(tags).sort((a,b)=>(b[1]-a[1]))
        //console.log(tab_tags)
        const kw = tab_tags[0][0]
        console.log("Elected KW"+kw+"with :"+tab_tags[0][1])
        const soustab={}
        Object.keys(data).forEach((x)=>{
            if (data[x]["tags"].includes(kw)){
                soustab[x]=data[x]
                //console.log("Include : "+x+"KW : "+kw)
                soustab[x]["tags"].splice(soustab[x]["tags"].indexOf(kw),1)
                delete data[x]
            }
        })
        ret.children.push(extract_data(kw,soustab))
    }
    return ret
}

const jsonformat = extract_data("root",datas)
console.log(jsonformat)
jsontos = JSON.stringify(jsonformat, null, 2)
fs.writeFile("flare-2.json", jsontos, (err) => console.log(err))
//console.log(datas)
//console.log(res)