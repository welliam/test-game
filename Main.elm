module Main exposing (..)

import Html exposing (..)
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


init =
    ( { left = 10
      , top = 10
      , direction = Down
      , animationFrame = 0
      , moving = True
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
        [ Svg.Attributes.version "1.1", Svg.Attributes.x "0", Svg.Attributes.y "0", Svg.Attributes.viewBox "0 0 100 100" ]
        [ Svg.polygon [ Svg.Attributes.fill "333333", square left top 10 ] [] ]


subscriptions model =
    Time.every (Time.second / 30) Tick


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


update (Tick time) model =
    case model.moving of
        True ->
            ( move model, Cmd.none )

        False ->
            ( model, Cmd.none )


main =
    Html.program
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
