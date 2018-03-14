module Subscriptions exposing (subscriptions)

import Constants
import Keyboard
import Model exposing (..)
import Time


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every (Time.second / Constants.framesPerSecond) Tick
        , Keyboard.downs KeyDown
        , Keyboard.ups KeyUp
        ]
