module Hexapoda.UI
  ( Query
  , Input
  , Output
  , Monad
  , ui
  ) where

import Control.Monad.State.Class as State
import Control.Monad.Trans.Class (lift)
import Halogen.Component (Component, ParentDSL, ParentHTML, hoist, parentComponent)
import Halogen.Component.ChildPath (cp1, cp2)
import Halogen.HTML (HTML)
import Halogen.HTML as H
import Halogen.Query (action)
import Hexapoda.Authentication.UI as Authentication.UI
import Hexapoda.Prelude
import Hexapoda.Workspace.UI as Workspace.UI

data State      = SAuthenticated | SNotAuthenticated
data Query a    = QAuthenticated a
type ChildQuery = Workspace.UI.Query ⊕ Authentication.UI.Query ⊕ Const Void
type Input      = Unit
type Output     = Void
type Monad eff  = Authentication.UI.Monad eff
type Slot       = Unit + Unit + Void

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
  render SAuthenticated    = H.slot' cp1 unit (hoist lift Workspace.UI.ui) unit absurd
  render SNotAuthenticated = H.slot' cp2 unit Authentication.UI.ui         unit handle
    where handle Authentication.UI.OAuthenticated = Just $ action QAuthenticated

  eval :: Query ~> ParentDSL State Query ChildQuery Slot Output (Monad eff)
  eval (QAuthenticated next) = do
    State.put SAuthenticated
    pure next
