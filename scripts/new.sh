#!/usr/bin/env bash

read -p "Enter Service Name: " service
domain=$(cut -d'/' -f1 <<<"$service")
servicePath=${service//$domain\//}

if [ -d "$domain" ]; then
  echo "$domain is already exists."
  exit 1
else
  mkdir -p "$domain"
  echo "$domain"
  echo -n "$domain" >$domain/CNAME
fi

if [ -d "$domain/$servicePath" ]; then
  echo "$domain/$servicePath is already exists."
  exit 1
else
  mkdir -p "$domain/$servicePath"
fi

echo "cd $domain/$servicePath"
cd "$domain/$servicePath"

echo "npx create-react-app ."
npx create-react-app .

echo $domain
echo $servicePath

packageName="@creco.org/${service//\//-}"

packageJson=$(node -p "/*javascript*/ \
  var package = require('./package.json'); \
  package.name = '$packageName'; \
  package.scripts.build = 'PUBLIC_URL=\'/$servicePath\' ' + package.scripts.build; \
  JSON.stringify(package); \
")

echo $packageJson >"./package.json"
npx prettier --write "./package.json"

echo "$domain/$servicePath"
