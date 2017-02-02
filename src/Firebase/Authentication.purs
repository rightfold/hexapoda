module Firebase.Authentication
  ( Provider
  , User
  , newGitHubProvider
  , addScope
  , signInWithPopup
  ) where

import Firebase (FIREBASE)
import Hexapoda.Prelude

foreign import data Provider :: Type
foreign import data User     :: Type

foreign import newGitHubProvider
  :: ∀ eff. Eff (firebase :: FIREBASE | eff) Provider

foreign import addScope
  :: ∀ eff
   . Provider
  -> String
  -> Eff (firebase :: FIREBASE | eff) Unit

foreign import signInWithPopup
  :: ∀ eff
   . Provider
  -> Aff (firebase :: FIREBASE | eff) {user :: User}
