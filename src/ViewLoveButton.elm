module ViewLoveButton exposing (viewLoveButton)

import Alias exposing (Photo)
import Html exposing (Html, div, h2, i, img, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Types exposing (..)


viewLoveButton : Photo -> Html Msg
viewLoveButton photo =
    let
        buttonClass =
            --
            if photo.liked then
                "fa-heart"

            else
                "fa-heart-o"
    in
    div [ class "photo-like" ]
        [ i
            --
            [ class "fa" --
            , class buttonClass --
--            , onClick Types.ToggleLike --
            ]
            []
        ]
