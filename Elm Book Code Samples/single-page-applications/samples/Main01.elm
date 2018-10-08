module Main exposing (main)

import Html exposing (Html, a, div, h1, i, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
-- START:import.nav.routes
import Navigation
import Routes
-- END:import.nav.routes


---- MODEL ----


-- START:type.Page
type Page
    = PublicFeed
    | Account
    | NotFound
-- END:type.Page


-- START:model
type alias Model =
    { page : Page }


initialModel : Model
initialModel =
    { page = NotFound }
-- END:model


-- START:init
init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    setNewPage (Routes.match location) initialModel
-- END:init



---- VIEW ----


-- START:viewContent
viewContent : Page -> Html Msg
viewContent page =
    case page of
        PublicFeed ->
            h1 [] [ text "Public Feed" ]

        Account ->
            h1 [] [ text "Account" ]

        NotFound ->
            div [ class "not-found" ]
                [ h1 [] [ text "Page Not Found" ] ]
-- END:viewContent


view : Model -> Html Msg
-- START:view
view model =
    div []
        [ viewContent model.page ]
-- END:view



---- UPDATE ----


type Msg
    = NewRoute (Maybe Routes.Route)


-- START:setNewPage
setNewPage : Maybe Routes.Route -> Model -> ( Model, Cmd Msg )
setNewPage maybeRoute model =
    case maybeRoute of
        Just Routes.Home ->
            ( { model | page = PublicFeed }, Cmd.none )

        Just Routes.Account ->
            ( { model | page = Account }, Cmd.none )

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )
-- END:setNewPage


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewRoute maybeRoute ->
            setNewPage maybeRoute model


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



---- PROGRAM ----


main : Program Never Model Msg
-- START:main
main =
    Navigation.program (Routes.match >> NewRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
-- END:main
