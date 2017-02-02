module Main
  ( main
  ) where

import Control.Monad.Reader.Trans (runReaderT)
import Firebase (FIREBASE)
import Firebase.Authentication (Provider, addScope, newGitHubProvider)
import Halogen.Aff (HalogenEffects, awaitBody, runHalogenAff)
import Halogen.Component (hoist)
import Halogen.VDom.Driver (runUI)
import Hexapoda.Prelude
import Hexapoda.UI as UI

type Effects eff =
  ( firebase :: FIREBASE
  | eff
  )

main :: ∀ eff. Eff (HalogenEffects (Effects eff)) Unit
main = do
  provider <- newGitHubProvider
  addScope provider "repo"
  runHalogenAff $
    awaitBody >>= runUI (hoist (interpret provider) UI.ui) unit

interpret :: ∀ eff a. Provider -> UI.Monad eff a -> Aff (Effects eff) a
interpret p a = runReaderT a p
