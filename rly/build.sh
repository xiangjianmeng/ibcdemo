#!/bin/bash

VERSION=a3185c560bb15838d2f54e83441513cbb1f77a99

while getopts "v:" opt; do
  case $opt in
    v)
      echo "VERSION=$OPTARG"
      VERSION="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"
      ;;
  esac
done

git clone https://github.com/cosmos/relayer.git
cd relayer
git pull
git checkout $VERSION
cd ..

docker build --no-cache -t okexchain/relayer:$VERSION .
