l!/bin/bash

rly config init



mnemonic="crime dove school toast excite capable page wheat charge valley gloom audit"
default_key="testkey"

function  bal() {
    chain_id=${1}
    chain_key=${2}
    echo "${chain_id} ${chain_key} account balance: $(rly q bal ${chain_id} ${chain_key})"
}

function  restore_keys() {
    id=${1}
     echo "Key $(rly keys restore ${id} ${default_key} "${mnemonic}") imported from ${id} to relayer..."
}

#
##rly config add-chains chains/
#function  prepare() {
#    file1=${1}
#    chain_id=$(cat ${1} | jq -r '.value.chain-id')
#    rly chains add --file ${1}
#    restore_keys ${chain_id}
#    bal ${chain_id} ${default_key}
#}
#
#function  foreach_add_chain() {.
#    for file in ` ls $1 `
#        do
#            if [ -d $1"/"$file ]
#            then
#                 ergodic $1"/"$file
#            else
#              prepare $1/${file}
#            fi
#        done
#}
#
#foreach_add_chain ${PWD}/chains
#rly config add-paths ./paths
#
#



rly chains add-dir ./chains
rly paths add-dir ./paths
restore_keys theta-testnet-001
restore_keys exchain-64
restore_keys exchain-65
#restore_keys evmos_9001-2
#restore_keys evmos_9000-4
restore_keys nyancat-9
restore_keys osmo-test-4
restore_keys axelar-testnet-lisbon-3
# evmos
rly keys restore evmos_9000-4 testkey "${mnemonic}" --coin-type 60
rly keys restore evmos_9001-2 testkey "${mnemonic}" --coin-type 60
rly keys restore cronostestnet_338-3 testkey "${mnemonic}" --coin-type 60

rly chains list
rly paths list

bal theta-testnet-001 ${default_key}
bal exchain-64 ${default_key}
bal exchain-65 ${default_key}
bal evmos_9001-2 ${default_key}
bal evmos_9000-4 ${default_key}
bal  nyancat-9 ${default_key}
bal cronostestnet_338-3 ${default_key}
bal osmo-test-4 ${default_key}
bal axelar-testnet-lisbon-3 ${default_key}
#bal evmos_9000-4 ${default_key}



