. 00-project-variables.sh
source getTxFunc.sh

rm build-tx.sh
touch build-tx.sh

echo "cardano-cli transaction build \\" > build-tx.sh
echo "--babbage-era \\" >> build-tx.sh
echo "$NETWORK \\" >> build-tx.sh

echo "Choose Fees UTxO:"
chooseWalletUTxO $REFERENCE_WALLET
FEE_UTXO=${SELECTED_UTXO}
echo "--tx-in $FEE_UTXO \\" >> build-tx.sh
echo ""

echo "Claim reference UTxOs?"
while read anotherRefUtxo; do
    if [ "$anotherRefUtxo" == "no" ]; then
        break
    else
        echo "--------------------------------------------------------------------------------------------"
        echo "Choose Ref UTxO to Claim:"
        chooseWalletUTxO $REFERENCE_WALLET
        REF_UTXO=${SELECTED_UTXO}
        echo "--tx-in $REF_UTXO \\" >> build-tx.sh
        echo ""
        echo "--------------------------------------------------------------------------------------------"
        echo "Another UTxO? (Type no to stop)"
    fi
done


echo "--change-address $REFERENCE_ADDRESS \\" >> build-tx.sh
echo "--out-file tx.tx" >> build-tx.sh

echo "cardano-cli transaction sign \\" >> build-tx.sh
echo "--tx-body-file tx.tx \\" >> build-tx.sh
echo "$NETWORK \\" >> build-tx.sh
echo "--signing-key-file $REFERENCE_SKEY \\" >> build-tx.sh
echo "--out-file tx.sign" >> build-tx.sh

echo "cardano-cli transaction submit \\" >> build-tx.sh
echo "--tx-file tx.sign \\" >> build-tx.sh
echo "$NETWORK" >> build-tx.sh

. build-tx.sh