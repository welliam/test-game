module Main exposing (..)

import Constants
import Html
import Keyboard
import Model exposing (..)
import Subscriptions exposing (subscriptions)
import Time
import Update exposing (update)
import View exposing (view)


main : Program Never Model Msg
main =
    Html.program
        { init = Constants.init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
