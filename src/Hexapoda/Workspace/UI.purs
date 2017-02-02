module Hexapoda.Workspace.UI
  ( Query
  , Input
  , Output
  , Monad
  , ui
  ) where

import Control.Monad.State.Class as State
import Firebase.Authentication (User)
import Halogen.Component (Component, ParentDSL, ParentHTML, parentComponent)
import Halogen.HTML (HTML)
import Halogen.HTML as H
import Halogen.Query (action)
import Hexapoda.Authentication.UI as Authentication.UI
import Hexapoda.Prelude

data State      = SAuthenticated User | SNotAuthenticated
data Query a    = QAuthenticated User a
type ChildQuery = Authentication.UI.Query
type Input      = Unit
type Output     = Void
type Monad eff  = Authentication.UI.Monad eff
type Slot       = Unit

ui :: ∀ eff. Component HTML Query Input Output (Monad eff)
ui = parentComponent { initialState
                     , render
                     , eval
                     , receiver: const Nothing
                     }
  where
  initialState :: Input -> State
  initialState _ = SNotAuthenticated

  render :: State -> ParentHTML Query ChildQuery Slot (Monad eff)
  render (SAuthenticated _) = H.text "hi"
  render SNotAuthenticated = H.slot unit Authentication.UI.ui unit handle
    where handle (Authentication.UI.OAuthenticated user) =
            Just $ action (QAuthenticated user)

  eval :: Query ~> ParentDSL State Query ChildQuery Slot Output (Monad eff)
  eval (QAuthenticated user next) = do
    State.put $ SAuthenticated user
    pure next
