module Constants exposing (init, movementFrames, size)

import Model exposing (..)


movementFrames : Int
movementFrames =
    3


size : Int
size =
    3


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


init : ( Model, Cmd msg )
init =
    ( { position = initialPosition
      , movingFrom = initialPosition
      , direction = Down
      , inputs = initialInputs
      , walkingFrame = 0
      }
    , Cmd.none
    )
