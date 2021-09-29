#!/bin/bash
export PATH=$PATH:/Volumes/Macintosh\ HD2/node-v10.16.0-darwin-x64/bin

set `date +%Y%m%d`
#echo "Récupération des données dans ../cryptos-$*.json"

curl -sS "https://web-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?aux=circulating_supply,tags,max_supply,total_supply&convert=USD&cryptocurrency_type=all&limit=5000&sort=market_cap&sort_dir=desc&start=1"|json > ./cryptos-$*.json
