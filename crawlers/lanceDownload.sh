#!/bin/bash

array=(`cat ./cryptodate.lst`)

for file in ../files/cryptos-*.json ; do
  set `echo "$file"|cut -d '-' -f 2|cut -d '.' -f 1` # Remove - and . from file
  value=$*
  if [[ ! " ${array[@]} " =~ " ${value} " ]]; then
    echo "Date $*"
    coffee ./addNewCryptosFromFreshData.coffee $* > toto.json
    ret=$?
    if [[ $ret -gt 0 ]]; then
      echo "Commande à relancer"
      exit 1
    fi
    cp ./toto.json ../cryptos.json
    echo "$*" >> cryptodate.lst
  fi
done
echo "Terminé"
