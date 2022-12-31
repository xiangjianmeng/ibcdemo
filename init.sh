#!/bin/bash

set -e

function failOnExit() {
  $@
  if [ $? -ne 0 ]; then
    echo "["$@"] failed"
    exit
  fi
}

# install okc
echo "install okc"
mkdir -p $GOPATH/src/github.com/okex
okc_dir=$GOPATH/src/github.com/okex/exchain
if [ ! -d "$okc_dir" ]; then
  mkdir -p $GOPATH/src/github.com/okex
  cd $GOPATH/src/github.com/okex
  git clone https://github.com/okex/exchain.git
fi
cd $okc_dir
failOnExit git pull
failOnExit git checkout mxj/demo
failOnExit make install Venus1Height=1

# install rly
echo "install rly"
rly_location=$GOPATH/src/github.com/cosmos/relayer
if [ ! -d "$rly_location" ]; then
  mkdir -p $GOPATH/src/github.com/cosmos
  cd $GOPATH/src/github.com/cosmos
  git clone https://github.com/cosmos/relayer.git
fi
cd $GOPATH/src/github.com/cosmos/relayer
failOnExit git checkout 0d314ac54fa37716e573101c902ab5dae041e736
failOnExit make install

# install gaia
echo "install gaia"
gaia_location=$GOPATH/src/github.com/cosmos/gaia
if [ ! -d "$gaia_location" ]; then
  mkdir -p $GOPATH/src/github.com/cosmos
  cd $GOPATH/src/github.com/cosmos
  git clone https://github.com/cosmos/gaia.git
fi
cd $GOPATH/src/github.com/cosmos/gaia
git pull
failOnExit git checkout v7.0.3
failOnExit LDFLAGS="" make install

# download keplr-example
echo "download keplr-example"
mkdir -p $GOPATH/src/github.com/okex
example_location=$GOPATH/src/github.com/okex/keplr-example
if [ ! -d "$example_location" ]; then
  mkdir -p $GOPATH/src/github.com/okex
  cd $GOPATH/src/github.com/okex
  git clone https://github.com/okex/keplr-example.git
fi
cd $example_location
failOnExit git pull

echo "init over"
