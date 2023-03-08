{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}


module GPTE.Types
  ( TreasuryParam (..),
    TreasuryDatum (..),
    ProjectDetails (..),
    TreasuryAction (..),
    ProjectAction (..),
    EscrowParam (..),
    CommitmentEscrowDatum (..)
  )
where

import GHC.Generics (Generic)
import Plutus.V1.Ledger.Value
import Plutus.V2.Ledger.Api
import qualified PlutusTx
import PlutusTx.Prelude hiding (Semigroup (..), unless)
import Prelude (Show (..))
import qualified Prelude as Pr
import qualified Prelude as Haskell 
import Data.Aeson (FromJSON, ToJSON)
import Codec.Serialise.Class (Serialise)
import Data.Tagged (Tagged (Tagged))
import Prettyprinter (Pretty)


data TreasuryParam = TreasuryParam
  { tIssuerPolicyId :: CurrencySymbol,
    tContribTokenPolicyId :: CurrencySymbol,
    escrowContractHash :: ValidatorHash,
    tProjectTokenPolicyId :: CurrencySymbol,
    tProjectTokenName :: TokenName
  }
  deriving stock (Pr.Eq, Pr.Ord, Show, Generic)

PlutusTx.makeLift ''TreasuryParam

-- consider representing Issuer with a token, instead of PKH
data TreasuryDatum = TreasuryDatum
  { projectHashList :: [BuiltinByteString],
    issuerTokenName :: TokenName
  }
  deriving stock (Pr.Eq, Pr.Ord, Show, Generic)

PlutusTx.unstableMakeIsData ''TreasuryDatum

data ProjectDetails = ProjectDetails
  { contributorPkh :: PubKeyHash,
    lovelaceAmount :: Integer,
    tokenAmount :: Integer,
    expirationTime :: POSIXTime,
    projectHash :: BuiltinByteString
  }
  deriving stock (Pr.Eq, Pr.Ord, Show, Generic)

instance Eq ProjectDetails where
  {-# INLINEABLE (==) #-}
  ProjectDetails cP lA tA eT bH == ProjectDetails cP' lA' tA' eT' bH' =
    (cP == cP') && (lA == lA') && (tA == tA') && (eT == eT') && (bH == bH')

PlutusTx.unstableMakeIsData ''ProjectDetails
PlutusTx.makeLift ''ProjectDetails

data TreasuryAction = Commit ProjectDetails | Manage
  deriving stock (Show)

PlutusTx.makeIsDataIndexed ''TreasuryAction [('Commit, 0), ('Manage, 1)]
PlutusTx.makeLift ''TreasuryAction

data CommitmentEscrowDatum = CommitmentEscrowDatum
  { bedContributorPkh :: PubKeyHash,
    bedLovelaceAmount :: Integer,
    bedTokenAmount :: Integer,
    bedExpirationTime :: POSIXTime,
    bedProjectHash :: BuiltinByteString
  }
  deriving stock (Pr.Eq, Pr.Ord, Show, Generic)

instance Eq CommitmentEscrowDatum where
  {-# INLINEABLE (==) #-}
  CommitmentEscrowDatum bCP bLA bTA bET bBH == CommitmentEscrowDatum bCP' bLA' bTA' bET' bBH' =
    (bCP == bCP') && (bLA == bLA') && (bTA == bTA') && (bET == bET') && (bBH == bBH')

-- Alternative way of comparisons
-- a == b = (bedIssuerPkh       a == bedIssuerPkh      b) &&
--          (bedContributorPkh  a == bedContributorPkh b) &&
--          (bedLovelaceAmount  a == bedLovelaceAmount b) &&
--          (bedTokenAmount     a == bedTokenAmount    b) &&
--          (bedExpirationTime  a == bedExpirationTime b)

PlutusTx.unstableMakeIsData ''CommitmentEscrowDatum
PlutusTx.makeLift ''CommitmentEscrowDatum

data EscrowParam = EscrowParam
  { projectTokenPolicyId :: CurrencySymbol,
    projectTokenName :: TokenName,
    contribTokenPolicyId :: CurrencySymbol,
    treasuryIssuerPolicyId :: CurrencySymbol
  }
  deriving stock (Pr.Eq, Pr.Ord, Show, Generic)

PlutusTx.makeLift ''EscrowParam

data ProjectAction = Cancel | Distribute | Update
  deriving stock (Show)

PlutusTx.makeIsDataIndexed ''ProjectAction [('Cancel, 0), ('Distribute, 1), ('Update, 2)]
PlutusTx.makeLift ''ProjectAction



