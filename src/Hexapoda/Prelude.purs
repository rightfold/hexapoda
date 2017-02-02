module Hexapoda.Prelude
( module Control.Monad.Aff
, module Control.Monad.Eff
, module Data.Const
, module Data.Maybe
, module Prelude
, type (+)
, type (⊕)
) where

import Control.Monad.Aff (Aff)
import Control.Monad.Eff (Eff)
import Data.Const (Const)
import Data.Either (Either)
import Data.Functor.Coproduct (Coproduct)
import Data.Maybe (Maybe(..), maybe)
import Prelude

infixr 6 type Either as +
infixr 6 type Coproduct as ⊕
