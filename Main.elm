module Main exposing (..)

import Html exposing (..)
import Keyboard
import Svg
import Svg.Attributes
import Time


type alias Model =
    { left : Int
    , top : Int
    , direction : Direction
    , moving : Bool
    , animationFrame : Int
    }


type Direction
    = Up
    | Down
    | Left
    | Right


type alias Preferences =
    { speed : Int
    , width : Int
    , height : Int
    }


type Msg
    = Tick Time.Time
    | KeyDown Keyboard.KeyCode
    | KeyUp Keyboard.KeyCode


init =
    ( { left = 10
      , top = 10
      , direction = Down
      , animationFrame = 0
      , moving = False
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


move model =
    case model.direction of
        Up ->
            { model | top = model.top - 1 }

        Down ->
            { model | top = model.top + 1 }

        Right ->
            { model | left = model.left + 1 }

        Left ->
            { model | left = model.left - 1 }


handleKeyUp model _ =
    { model | moving = False }


handleKeyDown model code =
    case code of
        37 ->
            { model | moving = True, direction = Left }

        38 ->
            { model | moving = True, direction = Up }

        39 ->
            { model | moving = True, direction = Right }

        40 ->
            { model | moving = True, direction = Down }

        _ ->
            model


update msg model =
    case msg of
        Tick time ->
            case model.moving of
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
