module Main exposing (..)

import Html exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)


type alias Model =
    { time : Time }


type Msg
    = Tick Time


init =
    ( 0, Cmd.none )


getPosition n =
    case n of
        0 ->
            square 10 10 10

        1 ->
            square 10 20 10

        2 ->
            square 20 20 10

        3 ->
            square 20 10 10

        n ->
            getPosition (n - 4)


square left top size =
    let
        f x y =
            toString (left + x * size) ++ "," ++ toString (top + y * size)
    in
    points (f 0 0 ++ " " ++ f 0 1 ++ " " ++ f 1 1 ++ " " ++ f 1 0)


view n =
    svg
        [ version "1.1", x "0", y "0", viewBox "0 0 100 100" ]
        [ polygon [ fill "333333", getPosition n ] [] ]


subscriptions model =
    Time.every second Tick


update (Tick time) n =
    ( n + 1, Cmd.none )


main =
    Html.program
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }
