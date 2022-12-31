#!/bin/bash

KEY="captain"
CHAINID="exchain-67"
MONIKER="oec"
CURDIR=`dirname $0`

set -e
set -o errexit
set -a
set -m



CHAINID=$1
CHAINDIR=$2
RPCPORT=$3
P2PPORT=$4
RESTPORT=$5

startDaenom=true
if  [ -n "$8" ] ;then
  startDaenom=false
fi

echorun() {
  echo "------------------------------------------------------------------------------------------------"
  echo "["$@"]"
  $@
  echo "------------------------------------------------------------------------------------------------"
}

rm -rf ~/.exchaind
rm -rf ~/.exchaincli


run() {
    LOG_LEVEL=*:error,main:info,x/erc20:info,x/ibc/client:info,x/ibc/connection:info,x/ibc-transfer:info,x/ibc/channel:info,x/ibc/*:debug
    if [ "$startDaenom" = true ]; then
      echo "start run "
       nohup exchaind start --pruning=nothing --rpc.unsafe \
        --local-rpc-port ${RPCPORT} \
        --rpc.laddr="tcp://0.0.0.0:${RPCPORT}" \
        --rpc.external_laddr="0.0.0.0:${RPCPORT}" \
        --p2p.laddr="tcp://0.0.0.0:${P2PPORT}" \
        --log_level $LOG_LEVEL \
        --log_file json \
        --deliver-txs-mode=0 \
        --fast-query=false\
        --enable-gid \
        --iavl-commit-interval-height 10 \
        --iavl-output-modules evm=1,acc=1 \
        --trace \
        --home=$CHAINDIR/$CHAINID \
        --chain-id ${CHAINID} \
        --elapsed Round=1,CommitRound=1,Produce=1 \
        --rest.path_prefix="exchain" \
        --rest.laddr "tcp://0.0.0.0:${RESTPORT}" \
        --consensus.timeout_commit 2s >$CHAINDIR/$CHAINID/oec.txt 2>&1 &
    fi
    exit
}


set -x # activate debugging

HOME_SERVER=~/.exchaind

exchaincli config  chain-id $CHAINID
exchaincli config   output json
exchaincli config   indent true
exchaincli config   trust-node true
exchaincli config   keyring-backend test


exchaind init $MONIKER --chain-id $CHAINID

exchaincli keys add  captain --recover -m "puzzle glide follow cruel say burst deliver wild tragic galaxy lumber offer" --output json > ${HOME_SERVER}/validator_seed.json 2>&1
exchaincli keys add   admin16 --hd-path "m/44'/118'/0'/0/0" --algo secp256k1 --coin-type 118 --output json > ${HOME_SERVER}/key_seed.json 2>&1
exchaincli keys add --recover admin17 -m "antique onion adult slot sad dizzy sure among cement demise submit scare" -y
exchaincli keys add  --recover admin18 -m "lazy cause kite fence gravity regret visa fuel tone clerk motor rent" -y


# Change parameter token denominations to okt
cat $HOME_SERVER/config/genesis.json | jq '.app_state["staking"]["params"]["bond_denom"]="okt"' > $HOME_SERVER/config/tmp_genesis.json && mv $HOME_SERVER/config/tmp_genesis.json $HOME_SERVER/config/genesis.json
cat $HOME_SERVER/config/genesis.json | jq '.app_state["crisis"]["constant_fee"]["denom"]="okt"' > $HOME_SERVER/config/tmp_genesis.json && mv $HOME_SERVER/config/tmp_genesis.json $HOME_SERVER/config/genesis.json
cat $HOME_SERVER/config/genesis.json | jq '.app_state["gov"]["deposit_params"]["min_deposit"][0]["denom"]="okt"' > $HOME_SERVER/config/tmp_genesis.json && mv $HOME_SERVER/config/tmp_genesis.json $HOME_SERVER/config/genesis.json
cat $HOME_SERVER/config/genesis.json | jq '.app_state["mint"]["params"]["mint_denom"]="okt"' > $HOME_SERVER/config/tmp_genesis.json && mv $HOME_SERVER/config/tmp_genesis.json $HOME_SERVER/config/genesis.json

# Enable EVM
if [ "$(uname -s)" == "Darwin" ]; then
    sed -i "" 's/"enable_call": false/"enable_call": true/' $HOME_SERVER/config/genesis.json
    sed -i "" 's/"enable_create": false/"enable_create": true/' $HOME_SERVER/config/genesis.json
    sed -i "" 's/"enable_contract_blocked_list": false/"enable_contract_blocked_list": true/' $HOME_SERVER/config/genesis.json
else
    sed -i 's/"enable_call": false/"enable_call": true/' $HOME_SERVER/config/genesis.json
    sed -i 's/"enable_create": false/"enable_create": true/' $HOME_SERVER/config/genesis.json
    sed -i 's/"enable_contract_blocked_list": false/"enable_contract_blocked_list": true/' $HOME_SERVER/config/genesis.json
fi

# Allocate genesis accounts (cosmos formatted addresses)
exchaind add-genesis-account $(exchaincli keys show $KEY    -a ) 100000000okt
exchaind add-genesis-account $(exchaincli keys show admin16 -a ) 900000000okt
exchaind add-genesis-account $(exchaincli keys show admin17 -a ) 900000000okt
exchaind add-genesis-account $(exchaincli keys show admin18 -a ) 900000000okt

# Sign genesis transaction
exchaind gentx --name $KEY --keyring-backend test

# Collect genesis tx
exchaind collect-gentxs

# Run this to ensure everything worked and that the genesis file is setup correctly
exchaind validate-genesis
exchaincli config keyring-backend test

mv ~/.exchaind $CHAINDIR/$CHAINID
mv ~/.exchaincli/keyring-test-exchain $CHAINDIR/$CHAINID/keyring-test-exchain
run

