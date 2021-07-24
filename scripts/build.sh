#!/usr/bin/env bash

workspace=$(pwd)
commitId=$(git rev-parse HEAD)

serviceList=("creco.me/react" "divops.world/main" "blog.creco.me/main")

for i in ${!serviceList[@]}; do
  service=${serviceList[$i]}
  domain=$(cut -d'/' -f1 <<<"$service")
  echo "domain: $domain"
  servicePath=${service//$domain\//}
  echo "servicePath: $servicePath"

  sourceRoot=$workspace/$domain
  echo "sourceRoot: $sourceRoot"
  targetRoot=$workspace/../$domain
  echo "targetRoot: $targetRoot"

  if [ ! -d $sourceRoot ]; then
    pwd
    ls -al
    ls -al ../
    echo "There is no $sourceRoot"
    continue
  fi
  echo 5

  cd $workspace/../
  echo "https://$GITHUB_TOKEN@github.com/creco-org/$domain.git"
  echo 5.5
  git config --global user.email "creaticoding@gmail.com"
  git config --global user.name "CreatiCoding"
  git clone --depth=1 "https://$GITHUB_TOKEN@github.com/creco-org/$domain.git"
  echo 6

  # clean result
  rm -rf $targetRoot/*

  # mkdir target service
  mkdir -p $targetRoot/$servicePath
  echo 7

  # build
  cd $sourceRoot/$servicePath
  yarn cache clean
  yarn install

  yarn build
  echo 8

  # deploy
  cd $sourceRoot/$servicePath/build/ && (tar cf - .) | (
    cd $targetRoot/$servicePath
    tar xf -
  )
  echo 9

  cp $sourceRoot/CNAME $targetRoot/CNAME
  cp $sourceRoot/index.html $targetRoot/index.html

  echo "{\"version\":\"$commitId\", \"date\": \"$(date -R)\"}" >$targetRoot/$servicePath/version.json
  echo 10

  cd $targetRoot
  deployDate=$(date -R)
  git add -A
  git commit -m "deploy: $service $deployDate"
  git push origin main
  echo 11

  rm -rf $sourceRoot
  echo 12
done
