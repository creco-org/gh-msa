#!/usr/bin/env bash

# GITHUB_TOKEN=asdasd ./scripts/newRepo.sh divops.world

if [ -z "$1" ]; then
  echo "\$1 is empty"
  exit 1
fi

echo $GITHUB_TOKEN

curl --request POST \
  --header "authorization: Bearer ${GITHUB_TOKEN}" \
  https://api.github.com/orgs/creco-org/repos -d "{\"name\":\"$1\", \"private\":\"true\"}"
