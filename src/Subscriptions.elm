module Subscriptions exposing (subscriptions)

import Keyboard
import Model exposing (..)
import Time


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every (Time.second / 30) Tick
        , Keyboard.downs KeyDown
        , Keyboard.ups KeyUp
        ]
