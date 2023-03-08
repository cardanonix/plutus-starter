# Usage: chooseWalletUTxO <path to wallet>
# Where wallet includes the following files:
# payment.addr
# payment.skey
# payment.vkey
# pubKey.hash
# stake.skey
# stake.vkey

# Wallets with this structure are built with /cardano-toolbox/utilities/scripts/make-preprod-wallet.sh

function chooseWalletUTxO() {
	rm -f -r tmp
	mkdir tmp
	touch tmp/utxos.txt
	UTXOS_FILE="./tmp/utxos.txt"
	if [ -z "$1" ]
	then
		read -p "Enter Wallet Directory: " WALLET_DIRECTORY
	else
		WALLET_DIRECTORY=$1
	fi
	WALLET_ADDRESS=$(cat $WALLET_DIRECTORY/payment.addr)
	WALLET_KEY="$WALLET_DIRECTORY/payment.skey"
	./balance.sh $WALLET_ADDRESS > $UTXOS_FILE
	echo $WALLET_ADDRESS

	tail -n +3 $UTXOS_FILE > tmp.txt

	n=1
	while read -r line
	do
	  echo "$n: $line"
	  n=$((n+1))
	done < tmp.txt

	echo ""
	read -p 'TX row number: ' TMP
	TX_ROW_NUM="$(($TMP+2))"
	TX_ROW=$(sed "${TX_ROW_NUM}q;d" $UTXOS_FILE)
	SELECTED_UTXO="$(echo $TX_ROW | awk '{ print $1 }')#$(echo $TX_ROW | awk '{ print $2 }')"
	SELECTED_UTXO_LOVELACE=$(echo $TX_ROW | awk '{ print $3 }')
	SELECTED_UTXO_TOKENS=$(echo $TX_ROW | awk '{ print $6 }')
	SELECTED_UTXO_ASSET=$(echo $TX_ROW | awk '{ print $7 }')
	# echo "Ok, you selected $SELECTED_UTXO"
	# echo "With $SELECTED_UTXO_LOVELACE lovelace"
	# echo "And $SELECTED_UTXO_TOKENS $SELECTED_UTXO_ASSET"
}

function chooseContractUTxO() {
	rm -f -r tmp
	mkdir tmp
	touch tmp/utxos.txt
	UTXOS_FILE="./tmp/utxos.txt"
	if [ -z "$1" ]
	then
		read -p "Enter Contract Address: " cADDRESS
	else
		cADDRESS=$1
	fi
	./balance.sh $cADDRESS > $UTXOS_FILE
	echo $cADDRESS

	tail -n +3 $UTXOS_FILE > tmp.txt

	n=1
	while read -r line
	do
	  echo "$n: $line"
	  n=$((n+1))
	done < tmp.txt

	read -p 'TX row number: ' TMP
	TX_ROW_NUM="$(($TMP+2))"
	TX_ROW=$(sed "${TX_ROW_NUM}q;d" $UTXOS_FILE)
	SELECTED_UTXO="$(echo $TX_ROW | awk '{ print $1 }')#$(echo $TX_ROW | awk '{ print $2 }')"
	SELECTED_UTXO_LOVELACE=$(echo $TX_ROW | awk '{ print $3 }')
	SELECTED_UTXO_TOKENS=$(echo $TX_ROW | awk '{ print $6 }')
	SELECTED_UTXO_ASSET=$(echo $TX_ROW | awk '{ print $7 }')
	# echo "Ok, you selected $SELECTED_UTXO"
	# echo "With $SELECTED_UTXO_LOVELACE lovelace"
	# echo "And $SELECTED_UTXO_TOKENS $SELECTED_UTXO_ASSET"
}


# function getContractInputTx() {
# 	BALANCE_FILE=/tmp/contractBalances.txt
# 	rm -f $BALANCE_FILE
# 	if [ -z "$1" ]
# 	then
# 		read -p 'Contract Name: ' SELECTED_CONTRACT_NAME
# 	else
# 		echo 'Contract Name: ' $1
# 		SELECTED_CONTRACT_NAME=$1
# 	fi
#         if [ -z "$2" ]
#         then
# 	      ./cbalance.sh $SELECTED_CONTRACT_NAME Data > $BALANCE_FILE
#         else
#               ./$2/cbalance.sh $SELECTED_CONTRACT_NAME .. > $BALANCE_FILE
#         fi
# 	SELECTED_CONTRACT_ADDR=$(cat $SELECTED_CONTRACT_NAME.addr)
# 	cat $BALANCE_FILE
# 	read -p 'TX row number: ' TMP
# 	TX_ROW_NUM="$(($TMP+2))"
# 	TX_ROW=$(sed "${TX_ROW_NUM}q;d" $BALANCE_FILE)
# 	SELECTED_UTXO_CONTRACT="$(echo $TX_ROW | awk '{ print $1 }')#$(echo $TX_ROW | awk '{ print $2 }')"
# 	SELECTED_UTXO_LOVELACE=$(echo $TX_ROW | awk '{ print $3 }')
# 	SELECTED_UTXO_TOKENS=$(echo $TX_ROW | awk '{ print $6 }')
# }
