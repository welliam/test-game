module Model exposing (..)

import Keyboard
import Time


type alias Model =
    { position : Position
    , movingFrom : Position
    , inputs : Inputs
    , direction : Direction
    , walkingFrame : Int
    }


type alias Position =
    { left : Int, top : Int }


type Direction
    = Up
    | Down
    | Left
    | Right


type alias Inputs =
    { left : Bool
    , right : Bool
    , up : Bool
    , down : Bool
    }


type Msg
    = Tick Time.Time
    | KeyDown Keyboard.KeyCode
    | KeyUp Keyboard.KeyCode
