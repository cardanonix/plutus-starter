#!/usr/bin/env bash

# Update Treasury Datum
source 00-project-variables.sh
source getTxFunc.sh

rm build-tx.sh
touch build-tx.sh

# Write these!
export REDEEMER_ACTION_FILE="$PROJECTPATH/scripts/redeemers/Manage.json"

echo "cardano-cli transaction build \\" > build-tx.sh
echo "--babbage-era \\" >> build-tx.sh
echo "$NETWORK \\" >> build-tx.sh

echo ""
echo "--------------------------------------------------------------------------------------------"
echo "Choose Fees UTxO:"
chooseWalletUTxO $ISSUER_WALLET
TX_IN=${SELECTED_UTXO}
ISSUER_LOVELACE_IN=${SELECTED_UTXO_LOVELACE}
echo "--tx-in $TX_IN \\" >> build-tx.sh
echo "--tx-in-collateral $TX_IN \\" >> build-tx.sh
echo ""
echo "--------------------------------------------------------------------------------------------"
echo "Choose UTxO with Issuer Token:"
echo ""
chooseWalletUTxO $ISSUER_WALLET
ISSUER_UTXO=${SELECTED_UTXO}
ISSUER_ASSET=${SELECTED_UTXO_ASSET}
echo "--tx-in $ISSUER_UTXO \\" >> build-tx.sh
echo ""
echo "--------------------------------------------------------------------------------------------"

echo "Choose Treasury UTxO:"
chooseContractUTxO $TREASURY_ADDRESS
TREASURY_UTXO=${SELECTED_UTXO}
GIMBALS_IN_TREASURY=${SELECTED_UTXO_TOKENS}

echo "--tx-in $TREASURY_UTXO \\" >> build-tx.sh
echo "--spending-tx-in-reference $REFERENCE_UTXO_TREASURY_SCRIPT \\" >> build-tx.sh
echo "--spending-plutus-script-v2 \\" >> build-tx.sh
echo "--spending-reference-tx-in-inline-datum-present \\" >> build-tx.sh
echo "--spending-reference-tx-in-redeemer-file $REDEEMER_ACTION_FILE \\" >> build-tx.sh
echo "--tx-out $ISSUER_ADDRESS+\"1500000 + 1 $ISSUER_ASSET\" \\" >> build-tx.sh
echo "--tx-out $ISSUER_ADDRESS+\"1500000 + $GIMBALS_IN_TREASURY $GIMBAL_ASSET\" \\" >> build-tx.sh
echo "--change-address $ISSUER_ADDRESS \\" >> build-tx.sh
echo "--protocol-params-file protocol.json \\" >> build-tx.sh
echo "--out-file issuer-updates-treasury-datum.draft" >> build-tx.sh

cat build-tx.sh
. build-tx.sh

cardano-cli transaction sign \
--tx-body-file issuer-updates-treasury-datum.draft \
$NETWORK \
--signing-key-file $ISSUER_SKEY \
--out-file issuer-updates-treasury-datum.signed

cardano-cli transaction submit \
$NETWORK \
--tx-file issuer-updates-treasury-datum.signed