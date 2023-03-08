{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}

module GPTE.Compiler (writeProjectEscrowScript, writeProjectTreasuryScript) where

import Cardano.Api
import Codec.Serialise (serialise)
import qualified Data.ByteString.Lazy as LBS
import qualified Data.ByteString.Short as SBS
import qualified GPTE.EscrowValidator as Escrow
import qualified GPTE.TreasuryValidator as Treasury
import GPTE.Types
import qualified Plutus.V2.Ledger.Api
import Cardano.Api.Shelley (PlutusScript (..))
import PlutusTx.Prelude
import Prelude (FilePath, IO)

-- If we do not import Ledger, then
-- how to replace Ledger.Validator?

writeValidator :: FilePath -> Plutus.V2.Ledger.Api.Validator -> IO (Either (FileError ()) ())
writeValidator file = writeFileTextEnvelope @(PlutusScript PlutusScriptV2) file Nothing . PlutusScriptSerialised . SBS.toShort . LBS.toStrict . serialise . Plutus.V2.Ledger.Api.unValidatorScript

escrowParam :: EscrowParam
escrowParam =
  EscrowParam
    { projectTokenPolicyId = "fb45417ab92a155da3b31a8928c873eb9fd36c62184c736f189d334c",
      projectTokenName = "tGimbal",
      contribTokenPolicyId = "738ec2c17e3319fa3e3721dbd99f0b31fce1b8006bb57fbd635e3784",
      treasuryIssuerPolicyId = "94784b7e88ae2a6732dc5c0f41b3151e5f9719ea513f19cdb9aecfb3"
    }

writeProjectEscrowScript :: IO (Either (FileError ()) ())
writeProjectEscrowScript = writeValidator "output/escrow-validator-v1.1.0-ppbl-2023-02-test.plutus" $ Escrow.validator escrowParam

writeProjectTreasuryScript :: IO (Either (FileError ()) ())
writeProjectTreasuryScript =
  writeValidator "output/treasury-validator-v1.1.0-ppbl-2023-02.plutus" $
    Treasury.validator $
      TreasuryParam
        { tContribTokenPolicyId = "05cf1f9c1e4cdcb6702ed2c978d55beff5e178b206b4ec7935d5e056",
          escrowContractHash = "15a9a88cf6e6f4e806a853cede246d0430455d4944401b9b71309fca",
          tProjectTokenPolicyId = "fb45417ab92a155da3b31a8928c873eb9fd36c62184c736f189d334c",
          tProjectTokenName = "tGimbal",
          tIssuerPolicyId = "15a9a88cf6e6f4e806a853cede246d0430455d4944401b9b71309fca"
        }
