#!/bin/bash

echo '''
==================
usage: ./config.sh ./xxxx/test(path) "mnemonic" /data/rlys/mainnet/comdex
==================
'''

base_path=${1}
mnemonic=${2}
home_path=${base_path}/relayer

new_dir_name=${3}

rly config init --home ${home_path}
rly chains add-dir ${base_path}/chains --home ${home_path}
rly paths  add-dir ${base_path}/paths --home ${home_path}


default_key="testkey"

chains=$(rly chains list --home ${home_path} | awk '{print $2}')
echo "chain list:" ${chains}
chain_list=($chains)
for ((i = 0; i < ${#chain_list[@]}; i++))
do
    if [ ${chain_list[i]} = "exchain-66" ]; then
      rly keys restore ${chain_list[i]} ${default_key} "${mnemonic}" --home ${home_path} --coin-type 60
    else
      rly keys restore ${chain_list[i]} ${default_key} "${mnemonic}" --home ${home_path}
    fi
    rly q bal ${chain_list[i]} ${default_key} --home ${home_path}
done

mkdir -p ${new_dir_name}


paths=$(rly paths list --home ${home_path} | awk '{print $2}')
echo "path list:" ${paths}
path_list=($paths)
for ((i = 0; i <=0; i++))
do
echo "
version: '2'
services:
  ${path_list[i]}:
    container_name: mainnet_rly_${path_list[i]}
    image: okexchain/relayer:v2.0.0-rc4
    restart: on-failure
    environment:
      - IBC_PATH=${path_list[i]}
    volumes:
      - ${new_dir_name}/relayer:/root/.relayer/
" >${path_list[i]}.yaml

cp  ${path_list[i]}.yaml ${new_dir_name}/docker-compose.yaml

done



cp -r ${home_path} ${new_dir_name}/

chmod -R 777 ${new_dir_name}








