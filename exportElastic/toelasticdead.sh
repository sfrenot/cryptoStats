#!/bin/bash

source ./elastic.creds
ad='localhost:9100'

echo > data_elastic.json  # On vide le fichier de données à transférer
new=0  # Indiquateur de nouvelles données

array=(`cat ./dead.lst`)

for file in ../files/cryptos-*.json ; do
  set `echo "$file"|cut -d '-' -f 2|cut -d '.' -f 1` # Remove - and . from file
  value=$*
  if [[ ! " ${array[@]} " =~ " ${value} " ]]; then
    new=1
    echo "Date $*"
    coffee deadsToElastic.coffee $* >> data_elastic.json
    echo "$*" >> dead.lst
    echo "sleep"
    sleep 2
  fi
done

if [[ new -eq 1 ]]; then
  echo "curl -u $user:$passwd -sS -XPUT $ad/_bulk -H'Content-Type: application/json' --data-binary @data_elastic.json|json"
else
  echo "Pas de nouvelles données"
fi
