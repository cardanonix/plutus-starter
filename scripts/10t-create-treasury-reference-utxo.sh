#!/usr/bin/env bash

# Create Reference Scripts

. 00-project-variables.sh
source getTxFunc.sh

if [ -z "$1" ]
then
    amtA=2000000
else
    amtA=$1
fi

echo "--------------------------------------------------------------------------------------------"
echo "Choose Lovelace UTxO:"
chooseWalletUTxO $REFERENCE_WALLET
TX_IN=${SELECTED_UTXO}
echo ""

cardano-cli transaction build \
--babbage-era \
$NETWORK \
--tx-in $TX_IN \
--tx-out $REFERENCE_ADDRESS+$amtA \
--tx-out-reference-script-file $TREASURY_PLUTUS_SCRIPT \
--change-address $REFERENCE_ADDRESS \
--protocol-params-file protocol.json \
--out-file create-reference-utxos-mentor.draft

cardano-cli transaction sign \
--tx-body-file create-reference-utxos-mentor.draft \
$NETWORK \
--signing-key-file $REFERENCE_SKEY \
--out-file create-reference-utxos-mentor.signed

cardano-cli transaction submit \
$NETWORK \
--tx-file create-reference-utxos-mentor.signed

echo ""
