#!/bin/bash

source ./elastic.creds
ad='localhost:9100'

echo "curl -u $user:$passwd -sS --location --request PUT "$ad/cryptos" |json"
echo "curl -u $user:$passwd -sS --location --request PUT "$ad/cryptos/_settings" --header 'Content-Type: application/json' --data-raw '{
  "index.mapping.total_fields.limit": 5000
}' |json"
