module Main exposing (baseUrl, initialModel, main, update, view)

import Alias exposing (Model, Photo, Feed)
import Browser exposing (document)
import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Http
import Json.Decode exposing (Decoder, bool, int, list, string, succeed)
import Json.Decode.Pipeline exposing (hardcoded, required)
import Types exposing (Msg)
import ViewPhotoDetail exposing (..)


photoDecoder : Decoder Photo
photoDecoder =
    succeed Photo
        |> required "id" int
        |> required "url" string
        |> required "caption" string
        |> required "liked" bool
        |> required "comments" (list string)
        |> hardcoded ""


baseUrl : String
baseUrl =
    "https://programming-elm.com/"


initialModel : Model
initialModel =
    { feed = Nothing
    }


init : () -> ( Model, Cmd Msg )
init () =
    ( initialModel, fetchFeed )


fetchFeed : Cmd Msg
fetchFeed =
    Http.get (baseUrl ++ "feed") (list photoDecoder)
        |> Http.send Types.LoadFeed


viewFeed : Maybe Feed -> Html Msg
viewFeed maybeFeed =
    case maybeFeed of
        Just feed ->
           div [] (List.map viewPhotoDetail feed)

        Nothing ->
            div [ class "loading-feed" ]
                [ text "Loading feed..." ]


view : Model -> Html Msg
view model =
    div []
        [ div [ class "header" ]
            [ h1 [] [ text "picshare" ] ]
        , div [ class "content-flow" ]
            [ viewFeed model.feed ]
        ]


toggleLike : Photo -> Photo
toggleLike photo =
    { photo | liked = not photo.liked }


updateComment : String -> Photo -> Photo
updateComment comment photo =
    { photo | newComment = comment }


updateFeed : (Photo -> Photo) -> Maybe Photo -> Maybe Photo
updateFeed updatePhoto maybePhoto =
    Maybe.map updatePhoto maybePhoto


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        --        Types.ToggleLike ->
        --            ( { model
        --                | photo = updateFeed toggleLike model.photo
        --              }
        --            , Cmd.none
        --            )
        --
        --        Types.SaveComment ->
        --            ( { model
        --                | photo = updateFeed saveNewComment model.photo
        --              }
        --            , Cmd.none
        --            )
        --
        --        Types.UpdateComment comment ->
        --            ( { model
        --                | photo = updateFeed (updateComment comment) model.photo
        --              }
        --            , Cmd.none
        --            )
        Types.LoadFeed (Ok feed) ->
            ( { model | feed = Just feed }
            , Cmd.none
            )

        Types.LoadFeed (Err _) ->
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


saveNewComment : Photo -> Photo
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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
