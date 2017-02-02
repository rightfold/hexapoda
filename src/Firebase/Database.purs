module Firebase.Database
  ( once
  ) where

import Data.Argonaut.Core (Json)
import Firebase (FIREBASE)
import Hexapoda.Prelude

foreign import once
  :: ∀ eff. String -> Aff (firebase :: FIREBASE | eff) Json
