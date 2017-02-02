module Hexapoda.Workspace.UI
  ( Query
  , Input
  , Output
  , Monad
  , ui
  ) where

import Control.Monad.Aff.Class (liftAff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Exception (error)
import Control.Monad.Error.Class (throwError)
import Control.Monad.State.Class as State
import Data.Argonaut.Core as JSON
import Data.StrMap as StrMap
import Firebase (FIREBASE)
import Firebase.Authentication as FBA
import Firebase.Database as FBD
import Halogen.Component (Component, ComponentDSL, ComponentHTML, lifecycleComponent)
import Halogen.HTML (HTML)
import Halogen.HTML as H
import Halogen.Query (action)
import Hexapoda.Prelude

type State     = Array String
data Query a   = Initialize a
type Input     = Unit
type Output    = Void
type Monad eff = Aff (firebase :: FIREBASE | eff)

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
    projects <- liftAff getProjects
    State.put projects
    pure next


getProjects :: ∀ eff. Aff (firebase :: FIREBASE | eff) (Array String)
getProjects = do
    userID <- liftEff FBA.currentUser
              >>= maybe (throwError (error "not authenticated"))
                        (pure <<< FBA.userID)
    projects <- FBD.once ("users/" <> userID <> "/projects")
                <#> JSON.toObject
                <#> map StrMap.keys
                >>= maybe (throwError (error "bad structure")) pure
    pure projects
