module Firebase.Authentication
  ( Provider
  , User
  , userID
  , newGitHubProvider
  , addScope
  , currentUser
  , signInWithPopup
  ) where

import Firebase (FIREBASE)
import Hexapoda.Prelude

foreign import data Provider :: Type
foreign import data User     :: Type

foreign import userID :: User -> String

foreign import newGitHubProvider
  :: ∀ eff. Eff (firebase :: FIREBASE | eff) Provider

foreign import addScope
  :: ∀ eff
   . Provider
  -> String
  -> Eff (firebase :: FIREBASE | eff) Unit

foreign import currentUser
  :: ∀ eff. Eff (firebase :: FIREBASE | eff) (Maybe User)

foreign import signInWithPopup
  :: ∀ eff
   . Provider
  -> Aff (firebase :: FIREBASE | eff) Unit
