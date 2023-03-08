# Gimbal Project Treasury + Escrow

## Mainnet Instance 001
> Updated 2022-12-05

## Project Branches:
- `gpte-plutus-v2` on branch `mainnet-instance-001`
- `gpte-front-end` on branch `mainnet-instance-001`

## Tokens:
- Issuer PolicyID is: `d16a58d273f8192364d3b105b332984bc3e17fd57f9d9b0011e6c13f` - this is the same token that is used to manage Contributor Reference UTxOs, and can be minted from `ppbl-contributor-token`.
- Contributor PolicyID is: `4879ae2b0c3dd69864bfa29b13bb8e60712f4df2176f43aaa7b9aa3b`
- Project Token is `gimbal` with AssetID `2b0a04a7b60132b1805b296c7fcb3b217ff14413991bf76f72663c3067696d62616c`

## Project Variables
> Check out a different branch to see project variables in [/scripts/000-project-variables.sh](../scripts/000-project-variables.sh):

## Instance Parameters
> In [/src/GPTE/Compiler.hs](../src/GPTE/Compiler.hs)

```haskell
EscrowParam {
    projectTokenPolicyId = "2b0a04a7b60132b1805b296c7fcb3b217ff14413991bf76f72663c30",
    projectTokenName = "gimbal",
    contribTokenPolicyId = "4879ae2b0c3dd69864bfa29b13bb8e60712f4df2176f43aaa7b9aa3b",
    treasuryIssuerPolicyId = "d16a58d273f8192364d3b105b332984bc3e17fd57f9d9b0011e6c13f"
}

TreasuryParam {
    tContribTokenPolicyId = "4879ae2b0c3dd69864bfa29b13bb8e60712f4df2176f43aaa7b9aa3b",
    escrowContractHash = Escrow.escrowValidatorHash escrowParam,
    tProjectTokenPolicyId = "2b0a04a7b60132b1805b296c7fcb3b217ff14413991bf76f72663c30",
    tProjectTokenName = "gimbal",
    tIssuerPolicyId = "d16a58d273f8192364d3b105b332984bc3e17fd57f9d9b0011e6c13f"
}
```
