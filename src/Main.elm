module Main exposing (..)

import ViewPhotoDetail exposing (..)
import Html exposing (Html, div, h1, text)
import Browser exposing (document)
import Html.Attributes exposing (class)


-- MODEL

initialModel: {url: String, caption: String, liked: Bool}
initialModel =
    {url = "/images/one.jpg"
    , caption ="Surfing"
    , liked = False}

view: {url: String, caption: String} -> Html Msg
view model =
    div []
    [ div [ class "header" ]
    [ h1 [] [text "picshare"] ]
        , div [ class "content-flow" ]
        [ viewPhotoDetail model ]
    ]

type Msg
    = Like
    | Unlike

update:
    Msg
    -> initialModel
    -> initialModel

update msg model =
    case msg of --
        Like -> --
            {model | liked = True}
        Unlike ->
            {model | liked = False}

main: Program Never initialModel Msg
main =
   Html. initialModel