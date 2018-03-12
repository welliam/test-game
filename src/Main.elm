module Main exposing (..)

import Html exposing (..)
import Keyboard
import Svg
import Svg.Attributes
import Time


type alias Model =
    { left : Int
    , top : Int
    , inputs : Inputs
    , direction : Direction
    , animationFrame : Int
    }


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


initialInputs =
    { left = False
    , right = False
    , up = False
    , down = False
    }


init =
    ( { left = 10
      , top = 10
      , direction = Down
      , animationFrame = 0
      , inputs = initialInputs
      }
    , Cmd.none
    )


square left top size =
    let
        f x y =
            toString (left + x * size) ++ "," ++ toString (top + y * size)
    in
    Svg.Attributes.points (f 0 0 ++ " " ++ f 0 1 ++ " " ++ f 1 1 ++ " " ++ f 1 0)


view : Model -> Html.Html msg
view { left, top } =
    Svg.svg
        [ Svg.Attributes.version "1.1"
        , Svg.Attributes.x "0"
        , Svg.Attributes.y "0"
        , Svg.Attributes.viewBox "0 0 100 100"
        ]
        [ Svg.polygon
            [ Svg.Attributes.fill "333333"
            , square left top 3
            ]
            []
        ]


subscriptions model =
    Sub.batch
        [ Time.every (Time.second / 30) Tick
        , Keyboard.downs KeyDown
        , Keyboard.ups KeyUp
        ]


withinLimits upperLimit value =
    if value < 0 then
        0
    else if value > upperLimit then
        upperLimit
    else
        value


move model =
    case model.direction of
        Up ->
            { model | top = withinLimits 50 (model.top - 1) }

        Down ->
            { model | top = withinLimits 50 (model.top + 1) }

        Right ->
            { model | left = withinLimits 50 (model.left + 1) }

        Left ->
            { model | left = withinLimits 50 (model.left - 1) }


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


isMoving model =
    let
        inputs =
            model.inputs
    in
    inputs.left || inputs.right || inputs.up || inputs.down


update msg model =
    case msg of
        Tick time ->
            case isMoving model of
                True ->
                    ( move model, Cmd.none )

                False ->
                    ( model, Cmd.none )

        KeyUp msg ->
            ( handleKeyUp model msg, Cmd.none )

        KeyDown msg ->
            ( handleKeyDown model msg, Cmd.none )


main =
    Html.program
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
