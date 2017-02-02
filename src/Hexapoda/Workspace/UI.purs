module Hexapoda.Workspace.UI
  ( Query
  , Input
  , Output
  , Monad
  , ui
  ) where

import Control.Monad.Aff.AVar (AVAR)
import Control.Monad.Aff.Class (class MonadAff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.State.Class as State
import Data.Argonaut.Core as JSON
import Data.StrMap as StrMap
import Firebase (FIREBASE)
import Firebase.Authentication as FBA
import Firebase.Database as FBD
import Halogen.Component (Component, ComponentDSL, ComponentHTML, lifecycleComponent)
import Halogen.HTML (HTML)
import Halogen.HTML as H
import Halogen.Query (action, subscribe)
import Halogen.Query.EventSource (EventSource, SubscribeStatus(..), eventSource')
import Hexapoda.Prelude

type State     = Array String
data Query a   = Initialize a | Update (Array String) a
type Input     = Unit
type Output    = Void
type Monad eff = Aff (avar :: AVAR, firebase :: FIREBASE | eff)

ui :: ∀ eff. Component HTML Query Input Output (Monad eff)
ui = lifecycleComponent { initialState
                        , render
                        , eval
                        , receiver:    const Nothing
                        , initializer: Just $ action Initialize
                        , finalizer:   Nothing
                        }
  where
  initialState :: Input -> State
  initialState _ = []

  render :: State -> ComponentHTML Query
  render projects = H.ul [] (map entry projects)
    where entry project = H.li [] [H.text project]

  eval :: Query ~> ComponentDSL State Query Output (Monad eff)
  eval (Initialize next) = do
    subscribe $ projectEvents (Just <<< Update `flip` Listening)
    pure next
  eval (Update projects next) = do
    State.put projects
    pure next

projectEvents
  :: ∀ eff m f
   . (MonadAff (avar :: AVAR, firebase :: FIREBASE | eff) m)
  => (Array String -> Maybe (f SubscribeStatus))
  -> EventSource f m
projectEvents handle = eventSource' attach handle
  where
  attach k = do
    userID <- liftEff FBA.currentUser
              <#> maybe "nil" FBA.userID
    FBD.on ("users/" <> userID <> "/projects") \value ->
      pure value
      <#> JSON.toObject
      <#> map StrMap.keys
      <#> fromMaybe []
      >>= k
