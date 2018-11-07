module Update exposing (update)

import Constants
import Model exposing (..)


withinLimits : Int -> Int -> Int
withinLimits upperLimit value =
    if value < 0 then
        0
    else if value > upperLimit then
        upperLimit
    else
        value


decrementWalking : Model -> Model
decrementWalking model =
    let
        player =
            model.player
    in
        { model | player = { player | walkingFrame = player.walkingFrame - 1 } }


resetDirection : Model -> Model
resetDirection model =
    let
        player =
            model.player

        newDirection =
            if model.inputs.left then
                Left
            else if model.inputs.right then
                Right
            else if model.inputs.up then
                Up
            else if model.inputs.down then
                Down
            else
                model.player.direction
    in
        { model | player = { player | direction = newDirection } }


handleKeyUp : Model -> Int -> Model
handleKeyUp model code =
    let
        inputs =
            model.inputs
    in
        case code of
            37 ->
                { model | inputs = { inputs | left = False } }

            38 ->
                { model | inputs = { inputs | up = False } }

            39 ->
                { model | inputs = { inputs | right = False } }

            40 ->
                { model | inputs = { inputs | down = False } }

            _ ->
                model


handleKeyDown : Model -> Int -> Model
handleKeyDown model code =
    let
        inputs =
            model.inputs
    in
        case code of
            37 ->
                { model
                    | inputs = { inputs | left = True }
                }

            38 ->
                { model
                    | inputs = { inputs | up = True }
                }

            39 ->
                { model
                    | inputs = { inputs | right = True }
                }

            40 ->
                { model
                    | inputs = { inputs | down = True }
                }

            _ ->
                model


getMovingTo : Direction -> Position -> Position
getMovingTo direction { top, left } =
    case direction of
        Up ->
            { top = top - 1, left = left }

        Down ->
            { top = top + 1, left = left }

        Right ->
            { top = top, left = left + 1 }

        Left ->
            { top = top, left = left - 1 }


startMoving : Model -> Model
startMoving model =
    let
        moved =
            decrementWalking model

        player =
            moved.player
    in
        { moved
            | player =
                { player
                    | walkingFrame = Constants.movementFrames
                    , movingFrom = player.position
                    , position = getMovingTo player.direction player.position
                }
        }


willMove : Model -> Bool
willMove model =
    let
        { left, right, up, down } =
            model.inputs

        wantsToMove =
            left || right || up || down

        { player } =
            model

        direction =
            if left then
                Left
            else if right then
                Right
            else if up then
                Up
            else
                Down

        spaceIsFree =
            not (List.member (getMovingTo direction player.position) model.blocks)
    in
        wantsToMove && spaceIsFree


isMoving : Model -> Bool
isMoving model =
    model.player.walkingFrame /= 0


handleMovements : Model -> Model
handleMovements model =
    if isMoving model then
        decrementWalking model
    else if willMove model then
        startMoving (resetDirection model)
    else
        resetDirection model


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Tick time ->
            ( handleMovements model, Cmd.none )

        KeyUp msg ->
            ( handleKeyUp model msg, Cmd.none )

        KeyDown msg ->
            ( handleKeyDown model msg, Cmd.none )
