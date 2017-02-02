module Firebase.Database
  ( on
  ) where

import Data.Argonaut.Core (Json)
import Firebase (FIREBASE)
import Hexapoda.Prelude

foreign import on
  :: ∀ eff
   . String
  -> (Json -> Eff (firebase :: FIREBASE | eff) Unit)
  -> Eff (firebase :: FIREBASE | eff) (Eff (firebase :: FIREBASE | eff) Unit)
