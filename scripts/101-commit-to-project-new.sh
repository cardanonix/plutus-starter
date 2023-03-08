#!/usr/bin/env bash

source 00-project-variables.sh
source getTxFunc.sh

. writeProjectCommitmentDatumAndRedeemer.sh

rm build-tx.sh
touch build-tx.sh

echo "cardano-cli transaction build \\" > build-tx.sh
echo "--babbage-era \\" >> build-tx.sh
echo "$NETWORK \\" >> build-tx.sh

echo ""
echo "--------------------------------------------------------------------------------------------"
echo "Choose Fees UTxO:"
chooseWalletUTxO $CONTRIBUTOR_TEST_WALLET
TX_IN=${SELECTED_UTXO}
echo "--tx-in $TX_IN \\" >> build-tx.sh
echo "--tx-in-collateral $TX_IN \\" >> build-tx.sh
echo ""
echo "--------------------------------------------------------------------------------------------"
echo "Choose UTxO with Contributor Token:"
echo ""
chooseWalletUTxO $CONTRIBUTOR_TEST_WALLET
CONTRIBUTOR_UTXO=${SELECTED_UTXO}
CONTRIBUTOR_ASSET=${SELECTED_UTXO_ASSET}
echo "--tx-in $CONTRIBUTOR_UTXO \\" >> build-tx.sh
echo ""
echo "--------------------------------------------------------------------------------------------"

echo "Choose Treasury UTxO:"
chooseContractUTxO $TREASURY_ADDRESS
TREASURY_UTXO=${SELECTED_UTXO}
TREASURY_ASSET=${SELECTED_UTXO_ASSET}
TREASURY_LOVELACE=${SELECTED_UTXO_LOVELACE}
TREASURY_GIMBALS=${SELECTED_UTXO_TOKENS}

read -p "Lovelace in Project: " LOVELACE_TO_ESCROW
read -p "Gimbals in Project: " GIMBALS_TO_ESCROW
LOVELACE_BACK_TO_TREASURY=$(expr $TREASURY_LOVELACE - $LOVELACE_TO_ESCROW)
GIMBALS_BACK_TO_TREASURY=$(expr $TREASURY_GIMBALS - $GIMBALS_TO_ESCROW)

echo "--tx-in $TREASURY_UTXO \\" >> build-tx.sh
echo "--spending-tx-in-reference $REFERENCE_UTXO_TREASURY_SCRIPT \\" >> build-tx.sh
echo "--spending-plutus-script-v2 \\" >> build-tx.sh
echo "--spending-reference-tx-in-inline-datum-present \\" >> build-tx.sh
echo "--spending-reference-tx-in-redeemer-file TreasuryRedeemer.json \\" >> build-tx.sh

echo "--tx-out $TREASURY_ADDRESS+\"$LOVELACE_BACK_TO_TREASURY + $GIMBALS_BACK_TO_TREASURY $TREASURY_ASSET\" \\" >> build-tx.sh
echo "--tx-out-inline-datum-file $TREASURY_DATUM_FILE \\" >> build-tx.sh

echo "--tx-out $ESCROW_ADDRESS+\"$LOVELACE_TO_ESCROW + 1 $CONTRIBUTOR_ASSET + $GIMBALS_TO_ESCROW $TREASURY_ASSET \" \\" >> build-tx.sh
echo "--tx-out-inline-datum-file EscrowDatum.json \\" >> build-tx.sh

echo "--change-address $CONTRIBUTOR_ADDRESS \\" >> build-tx.sh
echo "--protocol-params-file protocol.json \\" >> build-tx.sh
echo "--out-file contributor-commits-to-project.draft" >> build-tx.sh

. build-tx.sh
cat build-tx.sh

cardano-cli transaction sign \
--tx-body-file contributor-commits-to-project.draft \
$NETWORK \
--signing-key-file $CONTRIBUTOR_SKEY \
--out-file contributor-commits-to-project.signed

cardano-cli transaction submit \
$NETWORK \
--tx-file contributor-commits-to-project.signed