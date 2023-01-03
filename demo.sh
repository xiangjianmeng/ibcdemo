#!/bin/bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

function failOnExit() {
    $@
   if [ $? -ne 0 ]; then
        echo "["$@"] failed"
        exit
    fi
}

function  qualBal() {
    echo "========================="
    echo "ibc-1 testKey account balance: $(rly q bal ibc-1 testkey)"
    echo "exchain-101 admin16 account balance:$(rly q bal exchain-101 admin16)"
    echo "========================="
}

./init.sh
./two-chainz
sleep 15
qualBal

echo "start to establish links"
failOnExit rly tx link oec101_ibc1  -d -o 3s --override
echo "establishing link finished"
#failOnExit rly tx link oec101_ibc0  -d -o 3s --override
#failOnExit rly tx link oec101_oec100 -d -o 3s --override

#failOnExit rly tx link oec100_ibc1  -d -o 3s --override
#failOnExit rly tx link oec100_ibc0  -d -o 3s --override
#failOnExit rly tx link oec100_oec101  -d -o 3s --override
#
#failOnExit rly tx link ibc1_oec101  -d -o 3s --override
#failOnExit rly tx link ibc1_oec100  -d -o 3s --override
#failOnExit rly tx link ibc1_ibc0  -d -o 3s --override
#
#failOnExit rly tx link ibc0_oec101  -d -o 3s --override
#failOnExit rly tx link ibc0_oec100  -d -o 3s --override
#failOnExit rly tx link ibc0_ibc1  -d -o 3s --override

#
rly chains list
rly paths list

#sleep 2
#rly tx transfer exchain-101 ibc-1 10000okt $(rly chains address ibc-1) --path oec101_ibc1
#sleep 5
#rly tx relay-pkts oec101_ibc1 -d
#sleep 5
#qualBal
#
### if erc20 AutoDeploymentEnabled is true, the token will be transferred to contract
#rly tx transfer ibc-1 exchain-101 1000000uatom raw:$(rly chains address exchain-101) --path oec101_ibc1
#sleep 5
#rly tx relay-pkts oec101_ibc1 -d
#sleep 5
#qualBal
#
### if erc20 AutoDeploymentEnabled is true, the token will be transferred to contract, the cli will be error
#rly tx transfer exchain-101 ibc-1 1000000ibc/27394fb092d2eccd56123c74f36e4c1f926001ceada9ca97ea622b25f41e5eb2 $(rly chains addr  ibc-1) --path oec101_ibc1
#sleep 5
#rly tx relay-pkts oec101_ibc1 -d
#sleep 5
#qualBal
#sleep 5
#qualBal


# add gaia test network and okc test network
$SCRIPTDIR/killbyname.sh npm
cd $GOPATH/src/github.com/okex/keplr-example || exit
# export NODE_OPTIONS=--openssl-legacy-provider
cd okc-test || exit
npm install
kill -2 `lsof -t -i:8081`
nohup npm run dev > $SCRIPTDIR/okc-keplr.log 2>&1 &
read -p "please open chrome to access http://localhost:8081 and input enter after approve: "
kill -2 `lsof -t -i:8081`

sleep 1

$SCRIPTDIR/killbyname.sh npm
cd ../gaia-test
npm install
sed -i "" 's#16659#10001#g' src/main.js
kill -2 `lsof -t -i:8082`
nohup npm run dev > $SCRIPTDIR/okc-keplr.log 2>&1 &
read -p "please open chrome to access http://localhost:8082 and input enter after approve: "
kill -2 `lsof -t -i:8082`

$SCRIPTDIR/killbyname.sh npm

sleep 5

echo "start relayer service"
rly start oec101_ibc1



