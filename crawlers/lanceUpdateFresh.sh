while true; do

  echo "Search crypto 1/2"
  coffee ./updateNew2WithCrawl.coffee > tokens.json
  ret=$?
  cp ./tokens.json ../cryptos.json
  if [[ $ret -gt 0 ]]; then
    echo "Fin"
    break
  fi

  # echo "Search crypto 2/2"
  # coffee ./updateNew2WithCrawl.coffee > tokens.json
  # ret=$?
  # cp ./tokens.json ../cryptos.json
  # if [[ $ret -gt 0 ]]; then
  #   echo "Fin"
  #   break
  # fi

  sleep 60

done
if [[ $ret -gt 1 ]]; then
  exit
fi
set `date +%Y%m%d`
echo "fichier stat-$*"
coffee ./statistics.coffee $* > ../files/stat-$*.txt
