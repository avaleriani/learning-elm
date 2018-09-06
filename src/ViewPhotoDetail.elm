module ViewPhotoDetail exposing (..)
import Html exposing (Html, div, h2, i, img, text)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)

viewPhotoDetail: {url: String, caption: String, liked: Bool} -> Html msg

viewPhotoDetail model =
     let
        buttonClass = --
            if model.liked then
                "fa-heart"
            else
                "fa-heart-o"
        msg = --
            if model.liked then
               Unlike
            else
               Like
    in
    div [ class "photo" ]
        [ img [src model.url] []
        , div [class "photo-info"]
            [ div [class "photo-like"]
                [ i --
                    [ class "fa" --
                    , class buttonClass --
                    , onClick msg --
                    ]
                    []
                ]
                , h2 [ class "caption" ] [ text model.caption ]
            ]
        ]