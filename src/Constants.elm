module Constants exposing (framesPerSecond, init, movementFrames, size)

import Model exposing (..)


movementFrames : Int
movementFrames =
    5


size : Int
size =
    5


initialInputs : Inputs
initialInputs =
    { left = False
    , right = False
    , up = False
    , down = False
    }


initialPosition : Position
initialPosition =
    { top = 1, left = 3 }


framesPerSecond : Float
framesPerSecond =
    30


playerAtPosition : Position -> Actor
playerAtPosition position =
    { position = position
    , movingFrom = position
    , direction = Down
    , walkingFrame = 0
    }


init : ( Model, Cmd msg )
init =
    ( { player = playerAtPosition initialPosition
      , inputs = initialInputs
      , blocks = [ { top = 5, left = 5 } ]
      , actors = [ playerAtPosition { top = 7, left = 1 } ]
      }
    , Cmd.none
    )
