module ViewLoveButton exposing (viewLoveButton)

import Alias exposing (..)
import Html exposing (Html, div, h2, i, img, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Types exposing (..)


viewLoveButton : Model -> Html Msg
viewLoveButton model =
    let
        buttonClass =
            --
            if model.liked then
                "fa-heart"

            else
                "fa-heart-o"
    in
    div [ class "photo-like" ]
        [ i
            --
            [ class "fa" --
            , class buttonClass --
            , onClick Types.ToggleLike --
            ]
            []
        ]
