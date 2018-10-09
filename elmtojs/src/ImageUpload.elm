port module ImageUpload exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on)
import Json.Decode as Decode exposing (succeed)


port uploadImages : () -> Cmd msg


type Msg
    = UploadImages


type alias Model =
    ()


onChange : msg -> Html.Attribute msg
onChange msg =
    on "change" (succeed msg)


init : () -> ( Model, Cmd Msg )
init _ =
    ( (), Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "imageUpload" ]
        [ label [ for "file-upload" ]
            [ text "+ add images" ]
        , input
            [ id "file-upload"
            , type_ "file"
            , multiple True
            , onChange UploadImages
            ]
            []
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UploadImages ->
            ( model, uploadImages () )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }
