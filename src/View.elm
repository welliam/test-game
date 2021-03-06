module View exposing (view)

import Constants
import Html exposing (..)
import Model exposing (Model, Position)
import Svg
import Svg.Attributes


getWalkingPixels : Position -> Position -> Int -> ( Float, Float )
getWalkingPixels from to walkingFrame =
    let
        fraction =
            toFloat walkingFrame / toFloat Constants.movementFrames

        left =
            (toFloat from.left * fraction + toFloat to.left * (1 - fraction)) / 2

        top =
            (toFloat from.top * fraction + toFloat to.top * (1 - fraction)) / 2
    in
        ( left * toFloat (Constants.size * 2), top * toFloat (Constants.size * 2) )


square : ( Float, Float ) -> Svg.Attribute msg
square ( positionX, positionY ) =
    let
        f x y =
            toString (positionX + toFloat (x * Constants.size))
                ++ ","
                ++ toString (positionY + toFloat (y * Constants.size))
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
        { player, inputs, blocks, actors } =
            model
    in
        div []
            [ div [] [ text ("position: " ++ toString player.position) ]
            , div [] [ text ("movingFrom: " ++ toString player.movingFrom) ]
            , div [] [ text ("walkingFrame: " ++ toString player.walkingFrame) ]
            , div [] [ text ("direction: " ++ toString player.direction) ]
            , div [] [ text ("inputs: " ++ toString inputs) ]
            , Svg.svg
                [ Svg.Attributes.version "1.1"
                , Svg.Attributes.x "0"
                , Svg.Attributes.y "0"
                , Svg.Attributes.viewBox "0 0 100 100"
                , Svg.Attributes.style "width: 340px; border: solid thin"
                ]
                ([ Svg.polygon
                    ([ Svg.Attributes.fill "333333"
                     , square (getWalkingPixels player.movingFrom player.position player.walkingFrame)
                     ]
                    )
                    []
                 ]
                    ++ (List.map
                            (\pos ->
                                Svg.polygon
                                    ([ Svg.Attributes.fill "333333"
                                     , square (getWalkingPixels pos pos 0)
                                     ]
                                    )
                                    []
                            )
                            blocks
                       )
                    ++ (List.map
                            (\actor ->
                                Svg.polygon
                                    ([ Svg.Attributes.fill "333333"
                                     , square
                                        (getWalkingPixels
                                            actor.movingFrom
                                            actor.position
                                            actor.walkingFrame
                                        )
                                     ]
                                    )
                                    []
                            )
                            actors
                       )
                )
            ]
