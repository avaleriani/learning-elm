module Main exposing (baseUrl, initialModel, main, update, view)

import Alias exposing (Model)
import Browser exposing (document)
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Types exposing (Msg)
import ViewPhotoDetail exposing (..)


baseUrl : String
baseUrl =
    "/images/"


initialModel : Model
initialModel =
    { url = baseUrl ++ "one.jpg"
    , caption = "Surfing"
    , liked = False
    , comments = [ "Leonardo", "Waluigi" ]
    , newComment = ""
    }


view : Model -> Html Msg
view model =
    div []
        [ div [ class "header" ]
            [ h1 [] [ text "picshare" ] ]
        , div [ class "content-flow" ]
            [ viewPhotoDetail model ]
        ]


update : Msg -> Model -> Model
update msg model =
    case msg of
        Types.ToggleLike ->
            { model | liked = not model.liked }

        Types.SaveComment ->
            saveNewComment model

        Types.UpdateComment comment ->
            { model | newComment = comment }


saveNewComment : Model -> Model
saveNewComment model =
    case model.newComment of
        "" ->
            model

        _ ->
            let
                comment =
                    String.trim model.newComment
            in
            { model
                | comments = model.comments ++ [ comment ]
                , newComment = ""
            }


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
