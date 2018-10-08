module Main exposing (main)

-- START:import.Account
import Account
-- END:import.Account
import Html exposing (Html, a, div, h1, i, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Navigation
import Routes


---- MODEL ----


-- START:type.Page
type Page
    = PublicFeed
    | Account Account.Model
    | NotFound
-- END:type.Page


type alias Model =
    { page : Page }


initialModel : Model
initialModel =
    { page = NotFound }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    setNewPage (Routes.match location) initialModel



---- VIEW ----


viewContent : Page -> Html Msg
viewContent page =
    case page of
        PublicFeed ->
            h1 [] [ text "Public Feed" ]

        -- START:viewContent.Account
        Account accountModel ->
            Account.view accountModel
                |> Html.map AccountMsg
        -- END:viewContent.Account

        NotFound ->
            div [ class "not-found" ]
                [ h1 [] [ text "Page Not Found" ] ]


view : Model -> Html Msg
view model =
    div []
        [ viewContent model.page ]



---- UPDATE ----


-- START:type.Msg
type Msg
    = NewRoute (Maybe Routes.Route)
    | AccountMsg Account.Msg
-- END:type.Msg


setNewPage : Maybe Routes.Route -> Model -> ( Model, Cmd Msg )
setNewPage maybeRoute model =
    case maybeRoute of
        Just Routes.Home ->
            ( { model | page = PublicFeed }, Cmd.none )

        Just Routes.Account ->
            let
                ( accountModel, accountCmd ) =
                    Account.init
            in
            ( { model | page = Account accountModel }
            , Cmd.map AccountMsg accountCmd
            )

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
-- START:update
update msg model =
    case ( msg, model.page ) of
        ( NewRoute maybeRoute, _ ) ->
            setNewPage maybeRoute model

        ( AccountMsg accountMsg, Account accountModel ) ->
            let
                ( updatedAccountModel, accountCmd ) =
                    Account.update accountMsg accountModel
            in
            ( { model | page = Account updatedAccountModel }
            , Cmd.map AccountMsg accountCmd
            )

        _ ->
            ( model, Cmd.none )
-- END:update


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



---- PROGRAM ----


main : Program Never Model Msg
main =
    Navigation.program (Routes.match >> NewRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
