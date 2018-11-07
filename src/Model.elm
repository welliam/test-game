module Model exposing (..)

import Keyboard
import Time


type alias Model =
    { player : Actor
    , inputs : Inputs
    , blocks : List Position
    , actors : List Actor
    }


type alias Actor =
    { position : Position
    , movingFrom : Position
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
