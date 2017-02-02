module Hexapoda.Authentication.UI
  ( Query
  , Input
  , Output(..)
  , Monad
  , ui
  ) where

import Control.Monad.Aff.Class (liftAff)
import Control.Monad.Reader.Class as Reader
import Control.Monad.Reader.Trans (ReaderT)
import Firebase (FIREBASE)
import Firebase.Authentication (Provider, signInWithPopup)
import Halogen.Component (Component, ComponentDSL, ComponentHTML, component)
import Halogen.HTML (HTML)
import Halogen.HTML as H
import Halogen.HTML.Events as E
import Halogen.Query (raise)
import Hexapoda.Prelude

type State     = Unit
data Query a   = QAuthenticate a
type Input     = Unit
data Output    = OAuthenticated
type Monad eff = ReaderT Provider (Aff (firebase :: FIREBASE | eff))

ui :: ∀ eff. Component HTML Query Input Output (Monad eff)
ui = component { initialState
               , render
               , eval
               , receiver: const Nothing
               }
  where
  initialState :: Input -> State
  initialState _ = unit

  render :: State -> ComponentHTML Query
  render _ = H.button [E.onClick (E.input_ QAuthenticate)] [H.text "Authenticate"]

  eval :: Query ~> ComponentDSL State Query Output (Monad eff)
  eval (QAuthenticate next) = do
    provider <- Reader.ask
    liftAff $ signInWithPopup provider
    raise OAuthenticated
    pure next
