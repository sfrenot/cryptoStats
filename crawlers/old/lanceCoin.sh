while true; do

  echo "Search coin 1/2"
  coffee ./crawlCoin.coffee > coin.json
  ret=$?
  cp ./coin.json ../cryptos.json
  if [[ $ret -gt 0 ]]; then
    echo "Fin"
    break
  fi

  echo "Search coin 2/2"
  coffee ./crawlCoin.coffee > coin.json
  ret=$?
  cp ./coin.json ../cryptos.json
  if [[ $ret -gt 0 ]]; then
    echo "Fin"
    break
  fi

  sleep 60

done
