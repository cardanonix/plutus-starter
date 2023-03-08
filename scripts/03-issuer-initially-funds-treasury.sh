#!/usr/bin/env bash

# Update Treasury Datum
source 00-project-variables.sh
source getTxFunc.sh

rm build-tx.sh
touch build-tx.sh

# Write these!
export REDEEMER_ACTION_FILE="$PROJECT_PATH/scripts/redeemers/Manage.json"
export NEW_DATUM_FILE="$PROJECT_PATH/scripts/datums/datum-treasury-with-project-hashes.json"

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
echo "Choose UTxO with tGimbal Tokens:"
chooseWalletUTxO $ISSUER_WALLET
TX_IN_GIMBAL=${SELECTED_UTXO}
ISSUER_GIMBALS_IN=${SELECTED_UTXO_TOKENS}
echo "--tx-in $TX_IN_GIMBAL \\" >> build-tx.sh
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

read -p "Number lovelace to Treasury: " LOVELACE_TO_TREASURY
read -p "Number tGimbals to Treasury: " GIMBALS_TO_TREASURY

LOVELACE_BACK_TO_ISSUER=$(expr $ISSUER_LOVELACE_IN - $LOVELACE_TO_TREASURY)
GIMBALS_BACK_TO_ISSUER=$(expr $ISSUER_GIMBALS_IN - $GIMBALS_TO_TREASURY)

echo "--tx-out $TREASURY_ADDRESS+\"$LOVELACE_TO_TREASURY + $GIMBALS_TO_TREASURY $GIMBAL_ASSET\" \\" >> build-tx.sh
echo "--tx-out-inline-datum-file $PROJECTPATH/scripts/datums/datum-treasury-with-project-hashes.json \\" >> build-tx.sh
echo "--tx-out $ISSUER_ADDRESS+\"1500000 + 1 $ISSUER_ASSET\" \\" >> build-tx.sh
echo "--tx-out $ISSUER_ADDRESS+\"1500000 + $GIMBALS_BACK_TO_ISSUER $GIMBAL_ASSET\" \\" >> build-tx.sh
echo "--change-address $ISSUER_ADDRESS \\" >> build-tx.sh
echo "--protocol-params-file protocol.json \\" >> build-tx.sh
echo "--out-file issuer-initializes-treasury.draft" >> build-tx.sh

cat build-tx.sh
. build-tx.sh

cardano-cli transaction sign \
--tx-body-file issuer-initializes-treasury.draft \
$NETWORK \
--signing-key-file $ISSUER_SKEY \
--out-file issuer-initializes-treasury.signed

cardano-cli transaction submit \
$NETWORK \
--tx-file issuer-initializes-treasury.signed