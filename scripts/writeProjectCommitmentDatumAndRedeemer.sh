read -p "Contributor Pub Key Hash: " CONTRIB_PKH
read -p "Lovelace in Project: " LOVELACE
read -p "Gimbals in Project: " GIMBALS
read -p "Expiration Time: " EXPIRATION_TIME
read -p "Project Hash: " PROJECT_HASH

touch EscrowDatum.json
touch TreasuryRedeemer.json

echo "{\"constructor\": 0, \"fields\": [" >> EscrowDatum.json
echo "{ \"bytes\": \"$CONTRIB_PKH\" }," >> EscrowDatum.json
echo "{ \"int\": $LOVELACE }," >> EscrowDatum.json
echo "{ \"int\": $GIMBALS }," >> EscrowDatum.json
echo "{ \"int\": $EXPIRATION_TIME }," >> EscrowDatum.json
echo "{ \"bytes\": \"$PROJECT_HASH\" }]}" >> EscrowDatum.json

echo "{\"constructor\": 0, \"fields\": [{\"constructor\": 0, \"fields\": [" >> TreasuryRedeemer.json
echo "{ \"bytes\": \"$CONTRIB_PKH\" }," >> TreasuryRedeemer.json
echo "{ \"int\": $LOVELACE }," >> TreasuryRedeemer.json
echo "{ \"int\": $GIMBALS }," >> TreasuryRedeemer.json
echo "{ \"int\": $EXPIRATION_TIME }," >> TreasuryRedeemer.json
echo "{ \"bytes\": \"$PROJECT_HASH\" }]}]}" >> TreasuryRedeemer.json