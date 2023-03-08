# Gimbal Project Treasury and Escrow
## PlutusV2

Updated 2023-01-03. See [changelog](./changelog.md).

## Project Branches:
- `current-preprod` and `mainnet-instance-001` are used in live deployments of GPTE
- Branches in a Plutus project should be seen as snapshots in time.
- Development can continue on `master` or feature branches as needed.

# Current Instances of GPTE:
- [Mainnet Instance 001](/instances/mainnet-instance-001.md)
- [Current Preprod Instance](/instances/current-preprod-instance.md): ready for testing

## Quick Reference: Parameters for project instance on given branch:
See [`000-project-variables.sh`](./scripts/000-project-variables.sh)

## Live Instances:
- Mainnet: [https://gpte.gimablabs.io](https://gpte.gimablabs.io)
- [Preprod](https://plutus-pbl-summer-2022-projects-gpte-gpte-git-587ccb-gimbalabs.vercel.app/)

## Table of Contents
1. Compile Plutus Scripts (Escrow and Treasury)
2. Build Addresses
3. Create the Reference Script UTxOs and Treasury Datum Reference UTxO
4. Create a Project Commitment with Appropriate use of Datum
5. Distribute a Commitment UTxO from Escrow Contract
6. Review Contract Error Messages
7. Explore: When is a reference UTxO helpful for Datum?
8. Decide What's Next: Currrent Project Listings

---

## 1. Compile Plutus Scripts
- As with the previous version of GPTE, we will need to define some Parameters for our Treasury and Escrow Validators.
- Remember that the hash of the Escrow script is a parameter in the Treasury Validator, so we'll need to compile Escrow first. A function in `GPTE.Compiler` computes the `escrowValidatorHash` as a `TreasuryParam`.

```haskell
escrowParam :: EscrowParam
escrowParam =
  EscrowParam
    { projectTokenPolicyId = "fb45417ab92a155da3b31a8928c873eb9fd36c62184c736f189d334c",
      projectTokenName = "tGimbal",
      contribTokenPolicyId = "738ec2c17e3319fa3e3721dbd99f0b31fce1b8006bb57fbd635e3784",
      treasuryIssuerPolicyId = "94784b7e88ae2a6732dc5c0f41b3151e5f9719ea513f19cdb9aecfb3"
    }

writeProjectTreasuryScript :: IO (Either (FileError ()) ())
writeProjectTreasuryScript =
  writeValidator "output/treasury-gpte-v2-with-project-hash2.plutus" $
    Treasury.validator $
      TreasuryParam
        { tContribTokenPolicyId = "738ec2c17e3319fa3e3721dbd99f0b31fce1b8006bb57fbd635e3784",
          escrowContractHash = Escrow.escrowValidatorHash escrowParam,
          tProjectTokenPolicyId = "fb45417ab92a155da3b31a8928c873eb9fd36c62184c736f189d334c",
          tProjectTokenName = "tGimbal",
          tIssuerPolicyId = "94784b7e88ae2a6732dc5c0f41b3151e5f9719ea513f19cdb9aecfb3"
        }
```


## 2. Build Addresses
Use `cardano-cli address build` as usual, to create addresses for each Contract. For example:
```bash
TREASURY_ADDRESS=addr_test1wpr838k666akr3p5k8tfcdfenrlzpueq2j87tp7zkx6mh8qm8maf8
ESCROW_ADDRESS=addr_test1wrlh2k4wqjhyjxvg4hnhtq8uqpzp99v97c9nm6075rjyhkqtjphn5
```

## 3. Create the Reference Script UTxOs and Treasury Datum Reference UTxO
In this Transaction, we:
- Create reference UTxOs for both Contracts: Treasury and Escrow
- Initialize the Treasury with tokens and inline Treasury Datum
- Make the Treasury Datum redundant by also placing inline Treasury Datum in a reference UTxO. This can be used for outside verification of the system, and for experimenting with the dapp.

#### To Do:
- Build scripts for initializing a Treasury and creating Reference UTxOs

#### Set Variables:
```bash
TX_IN_GIMBAL=
TX_IN_LOVELACE=
LOVELACE_TO_LOCK=
GIMBAL_ASSET=
GIMBALS_TO_LOCK=
GIMBALS_BACK_TO_ISSUER=
REFERENCE_ADDRESS=
TREASURY_PLUTUS_SCRIPT=
ESCROW_PLUTUS_SCRIPT=
DATUM_FILE=
TREASURY_ADDRESS=

```

#### Build Transaction
```
cardano-cli transaction build \
--babbage-era \
--testnet-magic 1 \
--tx-in $TX_IN_GIMBAL \
--tx-in $TX_IN_LOVELACE \
--tx-out $REFERENCE_ADDRESS+21019870 \
--tx-out-reference-script-file $TREASURY_PLUTUS_SCRIPT \
--tx-out $REFERENCE_ADDRESS+22920580 \
--tx-out-reference-script-file $ESCROW_PLUTUS_SCRIPT \
--tx-out $REFERENCE_ADDRESS+1861920 \
--tx-out-inline-datum-file $DATUM_FILE \
--tx-out $TREASURY_ADDRESS+"$LOVELACE_TO_LOCK + $GIMBALS_TO_LOCK $GIMBAL_ASSET" \
--tx-out-inline-datum-file $DATUM_FILE \
--tx-out $SENDERPREPROD+"1500000 + $GIMBALS_BACK_TO_ISSUER $GIMBAL_ASSET" \
--change-address $SENDERPREPROD \
--protocol-params-file protocol.json \
--out-file issuer-locks-funds-in-treasury.draft

cardano-cli transaction sign \
--tx-body-file issuer-locks-funds-in-treasury.draft \
--testnet-magic 1 \
--signing-key-file $SENDERKEYPREPROD \
--out-file issuer-locks-funds-in-treasury.signed

cardano-cli transaction submit \
--testnet-magic 1 \
--tx-file issuer-locks-funds-in-treasury.signed
```

### You will get an error the first time you run this transaction "correctly".
- If you do everything else right, you should get an error saying that 2000000 lovelace is not enough to satisfy the minUTxO. Change the amount of lovelace being sent to the reference address accordingly.

## 4. Create a Project Commitment with Appropriate use of Datum
- Use the script [02-commit-to-project.sh](./scripts/02-commit-to-project.sh)
- Error checking
- Cost comparisons

## 5. Distribute a Commitment UTxO from Escrow Contract:
- Use the script [03-distribute-escrow-utxo-with-inline-datum.sh](./scripts/03-distribute-escrow-utxo-with-inline-datum.sh)

## Upcoming at Live Coding:
### 6. Review Contract Error Messages
### 7. Explore: When is a reference UTxO helpful for Datum?
### 8. Decide What's Next: Currrent Project Listings

## Tasks
- [ ] documenting new bash scripts