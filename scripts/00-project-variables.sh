# Updated 2022-12-05

VERSION="v1.1.0-ppbl-2023"

. local-secrets.sh
# For personal testing, create file called local-secrets.sh, and add these values:
# export CARDANO_NODE_SOCKET_PATH
# export PROJECTPATH
# export WALLETDIR

# -----------------------------------------------------------------------------------------------------
NETWORK="--testnet-magic 1"
cardano-cli query tip $NETWORK
cardano-cli query protocol-parameters $NETWORK --out-file protocol.json

# -----------------------------------------------------------------------------------------------------
#
# Set Policy IDs for all tokens in instance
#
# -----------------------------------------------------------------------------------------------------
export GIMBAL_ASSET="fb45417ab92a155da3b31a8928c873eb9fd36c62184c736f189d334c.7447696d62616c"
# Not required if using getTxFunc.sh:
# export CONTRIBUTOR_POLICY_ID="05cf1f9c1e4cdcb6702ed2c978d55beff5e178b206b4ec7935d5e056"
# export ISSUER_POLICY_ID="15a9a88cf6e6f4e806a853cede246d0430455d4944401b9b71309fca"


# -----------------------------------------------------------------------------------------------------
#
# Reference Wallet is for quickly adding and removing Reference UTxOs
#
# -----------------------------------------------------------------------------------------------------

export REFERENCE_WALLET="$WALLETDIR/PPBL2023ReferenceWallet"
export REFERENCE_ADDRESS=$(cat $REFERENCE_WALLET/payment.addr)
export REFERENCE_SKEY="$REFERENCE_WALLET/payment.skey"

# Needs update whenever these change:
export REFERENCE_UTXO_ESCROW_SCRIPT=7815005b3d138db79def10bf283f821740a7e4f6d8920da77a370860db6ba7e0#0
export REFERENCE_UTXO_TREASURY_SCRIPT=2a6792aa47bd2ca46f6ce4190d482cecf68b83b8fc414ab84bb2874091f08fb4#0

# -----------------------------------------------------------------------------------------------------
#
# Plutus Scripts and Validators
#
# -----------------------------------------------------------------------------------------------------
#
# Build an address and validator hash for Escrow Contract, then export each
ESCROW_PLUTUS_SCRIPT="${PROJECTPATH}/output/escrow-validator-${VERSION}.plutus"
cardano-cli address build --payment-script-file $ESCROW_PLUTUS_SCRIPT $NETWORK --out-file escrow.addr
cardano-cli transaction policyid --script-file $ESCROW_PLUTUS_SCRIPT > escrow.vhash
export ESCROW_ADDRESS=$(cat escrow.addr)
export ESCROW_VALIDATOR_HASH=$(cat escrow.vhash)

# Build an address and validator hash for Treasury Contract, then export each
TREASURY_PLUTUS_SCRIPT="${PROJECTPATH}/output/treasury-validator-${VERSION}.plutus"
cardano-cli address build --payment-script-file $TREASURY_PLUTUS_SCRIPT $NETWORK --out-file treasury.addr
cardano-cli transaction policyid --script-file $TREASURY_PLUTUS_SCRIPT > treasury.vhash
export TREASURY_ADDRESS=$(cat treasury.addr)
export TREASURY_VALIDATOR_HASH=$(cat treasury.vhash)



# -----------------------------------------------------------------------------------------------------
#
# You can set up wallets for testing:
#
# -----------------------------------------------------------------------------------------------------
#
export ISSUER_WALLET="$WALLETDIR/ppbl2023Admin1"
export ISSUER_ADDRESS=$(cat $ISSUER_WALLET/payment.addr)
export ISSUER_SKEY="$ISSUER_WALLET/payment.skey"

export CONTRIBUTOR_TEST_WALLET="$WALLETDIR/ppbl2023Contributor1"
export CONTRIBUTOR_ADDRESS=$(cat $CONTRIBUTOR_TEST_WALLET/payment.addr)
export CONTRIBUTOR_SKEY="$CONTRIBUTOR_TEST_WALLET/payment.skey"

export TREASURY_DATUM_FILE="${PROJECTPATH}/scripts/datums/datum-treasury-with-project-hashes.json"