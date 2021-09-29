# Main pages
Affiche une structuration des cryptos par mots-clés  
[CryptoStruct](https://txtweet.github.io/pr-noe/treemap/TreemapObservable.html)  

Affiche des arborescences de cryptos élaguée  
[treePruned](https://txtweet.github.io/pr-noe/visuforks/visuForks2.html)  

Affiche des arborescences de cryptos complète  
[treeFull](https://txtweet.github.io/pr-noe/visuforks/visuForks.html)  

# FAQ
Pour connaître le nombre de cryptos : grep '  },' cryptos.json |wc  
python -m SimpleHTTPServer 8000

# Crawling tools
Ils sont regroupés dans le dossier crawler.
Le but est de travailler sur le fichier cryptos.json

## crawl.coffee : http://www.coinmarketcap.com
> Ajoute de nouvelles cryptos au fichier cryptos.json, en se connectant au site coinmarketcap.

npm install coffee bluebird cheerio request request-promise lodash

Le script charge le fichier cryptos.json

- Pour lancer :
  `coffee ./crawl.coffee > cryptos2.json`
- Puis copier la sortie dans cryptos.json
  `mv ./cryptos2.json cryptos.json`

## lance.sh
> Script de lancement des appels pour générer des pauses

Un script shell : `lance.sh` automatise l'appel au crawler.

## InsertForkdropioInCryptos
> Script d'insertion des informations de fork issues de fordrop.io dans le fichier de description des monnaies

wget https://www.forkdrop.io/json/index.json  
Charger et sauver le fichier dans forkdropio.json  
Ajout d'un script d'injection des données de forkdrop dans cryptos.json
`coffee insertForksInCryptos.coffee`  

## crawlTokens
> Script de navigation dans coinmarket pour chercher les monnaies de type token et y insérer les information de fork
Navigue dans la liste cryptos.json pour trouver les forks

# Display tools
## visufork : createTree.coffee -> forked-cryptos.json -> visuForks.html
Création des forks
> coffee ./createTree.coffee > forked-cryptos.json

Visualisation des données
>open http://localhost:8000/visuForks.html.html

## Treemap : crytpostoD3coffee.coffee -> arbre-tag.json -> TreemapObservable.html
Création de l'arbre des tags
> cofee ./cryptostoD3coffee.coffee > arbre-tag.json

Lancer un serveur web pour ouvrir cette page (ex : `python -m http.server` )
`visuForksTreemap.html` est une version avec d3v4, l'affichage n'est pas fluide et peu lisible.

# Biblio
## biblio d3.js
> Un tutoriel rapide et simple avec un codepen à la fin
https://medium.com/nightingale/making-hierarchy-layouts-with-d3-hierarchy-fdb36d0a9c56
> La doc de d3-hierarchy, plus difficile à prendre en main, car ca passe par l'infrastructure observable
https://observablehq.com/@d3/tidy-tree

## Papiers
https://www.sciencedirect.com/science/article/abs/pii/S0743731520303117?via%3Dihub - SocialBlock
https://www.sciencedirect.com/science/article/abs/pii/S0140366420310252 - BSV-PAGS

Articles sur le fonctionnement de bitcoin dans le détail :  

http://www.righto.com/2014/02/bitcoin-mining-hard-way-algorithms.html  
http://www.righto.com/2014/02/bitcoins-hard-way-using-raw-bitcoin.html  

## Attaques
Attaque de surface? sur hyperledger  
https://par.nsf.gov/servlets/purl/10083311.  

## Sites
sites de statistiques  
https://www.blockchain.com/
https://coinmarketcap.com/currencies/zcash/  
https://blockchain.coinmarketcap.com/chain/bitcoin  
https://explorer.viawallet.com/halving  
wget -O toto.json https://web-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?aux=circulating_supply,tags,max_supply,total_supply&convert=USD&cryptocurrency_type=all&limit=5000&sort=market_cap&sort_dir=desc&start=1

## Consommation énergétique
https://ecoinfo.cnrs.fr/2020/02/11/consommation-energetique-des-technologies-blockchain/  
https://www.iea.org/commentaries/bitcoin-energy-use-mined-the-gap  

## Monnaies
BlackCoin : https://blackcoin.org/blackcoin-pos-protocol-v2-whitepaper.pdf  
Tether : https://tether.to/wp-content/uploads/2016/06/TetherWhitePaper.pdf  

## Cours
https://gramoli.redbellyblockchain.io/web/doc/chapter2.pdf



--- Liste des tags
"NoLicenceFile"
"External"
"NoGithub"
