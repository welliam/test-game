module Constants exposing (init, movementFrames, size)

import Model exposing (..)


movementFrames : Int
movementFrames =
    6


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


init : ( Model, Cmd msg )
init =
    ( { player =
            { position = initialPosition
            , movingFrom = initialPosition
            , direction = Down
            , walkingFrame = 0
            }
      , inputs = initialInputs
      }
    , Cmd.none
    )
