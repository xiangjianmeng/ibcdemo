#!/bin/bash
mnemonic="crime dove school toast excite capable page wheat charge valley gloom audit"
default_key="testkey"
rly chains add --file ./chains/evmo_9000-4.json
rly paths add exchain-64 evmo_9000-4 okc64-evmos-testnet --file ./paths/okc64-evmos-testnet.json

# evmos
rly keys restore evmos_9000-4 testkey "${mnemonic}" --coin-type 60
