module Main exposing (..)

import Html exposing (..)
import Keyboard
import Svg
import Svg.Attributes
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


getWalkingPixels : Position -> Position -> Int -> ( Float, Float )
getWalkingPixels from to walkingFrame =
    let
        fraction =
            toFloat walkingFrame / toFloat movementFrames

        left =
            (toFloat from.left * fraction + toFloat to.left * (1 - fraction)) / 2

        top =
            (toFloat from.top * fraction + toFloat to.top * (1 - fraction)) / 2
    in
    ( left * toFloat (size * 2), top * toFloat (size * 2) )


square : ( Float, Float ) -> Svg.Attribute msg
square ( positionX, positionY ) =
    let
        f x y =
            toString (positionX + toFloat (x * size))
                ++ ","
                ++ toString (positionY + toFloat (y * size))
    in
    Svg.Attributes.points
        (f 0 0
            ++ " "
            ++ f 0 1
            ++ " "
            ++ f 1 1
            ++ " "
            ++ f 1 0
        )


view : Model -> Html.Html msg
view model =
    let
        { position, direction, movingFrom, walkingFrame } =
            model
    in
    div []
        [ div [] [ text ("position: " ++ toString position) ]
        , div [] [ text ("movingFrom: " ++ toString movingFrom) ]
        , div [] [ text ("walkingFrame: " ++ toString walkingFrame) ]
        , Svg.svg
            [ Svg.Attributes.version "1.1"
            , Svg.Attributes.x "0"
            , Svg.Attributes.y "0"
            , Svg.Attributes.viewBox "0 0 100 100"
            , Svg.Attributes.style "border: solid thin;"
            ]
            [ Svg.polygon
                [ Svg.Attributes.fill "333333"
                , square (getWalkingPixels movingFrom position walkingFrame)
                ]
                []
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every (Time.second / 30) Tick
        , Keyboard.downs KeyDown
        , Keyboard.ups KeyUp
        ]


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
    { model | walkingFrame = model.walkingFrame - 1 }


resetDirection : Model -> Model
resetDirection model =
    let
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
                model.direction
    in
    { model | direction = newDirection }


handleKeyUp : Model -> Int -> Model
handleKeyUp model code =
    let
        inputs =
            model.inputs
    in
    resetDirection
        (case code of
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
        )


handleKeyDown : Model -> Int -> Model
handleKeyDown model code =
    let
        inputs =
            model.inputs
    in
    case code of
        37 ->
            { model | inputs = { inputs | left = True }, direction = Left }

        38 ->
            { model | inputs = { inputs | up = True }, direction = Up }

        39 ->
            { model | inputs = { inputs | right = True }, direction = Right }

        40 ->
            { model | inputs = { inputs | down = True }, direction = Down }

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
    in
    { moved
        | walkingFrame = movementFrames
        , movingFrom = model.position
        , position = getMovingTo model.direction model.position
    }


willMove : Model -> Bool
willMove model =
    let
        { left, right, up, down } =
            model.inputs
    in
    left || right || up || down


isMoving : Model -> Bool
isMoving model =
    model.walkingFrame /= 0


handleMovements : Model -> Model
handleMovements model =
    if isMoving model then
        decrementWalking model
    else if willMove model then
        startMoving model
    else
        model


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Tick time ->
            ( handleMovements model, Cmd.none )

        KeyUp msg ->
            ( handleKeyUp model msg, Cmd.none )

        KeyDown msg ->
            ( handleKeyDown model msg, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
