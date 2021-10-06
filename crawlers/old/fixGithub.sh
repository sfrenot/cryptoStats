while true; do

  # echo "Search github"
  coffee ./fixGithub.coffee > github.json
  ret=$?
  cp ./github.json ../cryptos.json
  if [[ $ret -gt 0 ]]; then
    echo "Fin"
    break
  fi

  sleep 3

done
