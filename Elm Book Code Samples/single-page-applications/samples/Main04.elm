module Main exposing (main)

import Account
import Html exposing (Html, a, div, h1, i, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Navigation
import Routes
-- START:import.wrappers
import PublicFeed
import UserFeed
-- END:import.wrappers


---- MODEL ----


-- START:type.Page
type Page
    = PublicFeed PublicFeed.Model
    | Account Account.Model
    | UserFeed UserFeed.Model
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


viewHeader : Html Msg
viewHeader =
    div [ class "header" ]
        [ div [ class "header-nav" ]
            [ a [ class "nav-brand", onClick (Visit Routes.Home) ]
                [ text "Picshare" ]
            , a [ class "nav-account", onClick (Visit Routes.Account) ]
                [ i [ class "fa fa-2x fa-gear" ] [] ]
            ]
        ]


viewContent : Page -> Html Msg
viewContent page =
    case page of
        PublicFeed publicFeedModel ->
            PublicFeed.view publicFeedModel
                |> Html.map PublicFeedMsg

        Account accountModel ->
            Account.view accountModel
                |> Html.map AccountMsg

        -- START:viewContent.UserFeed
        UserFeed userFeedModel ->
            UserFeed.view userFeedModel
                |> Html.map UserFeedMsg
        -- END:viewContent.UserFeed

        NotFound ->
            div [ class "not-found" ]
                [ h1 [] [ text "Page Not Found" ] ]


view : Model -> Html Msg
view model =
    div []
        [ viewHeader
        , viewContent model.page
        ]



---- UPDATE ----


-- START:type.Msg
type Msg
    = NewRoute (Maybe Routes.Route)
    | Visit Routes.Route
    | PublicFeedMsg PublicFeed.Msg
    | AccountMsg Account.Msg
    | UserFeedMsg UserFeed.Msg
-- END:type.Msg


setNewPage : Maybe Routes.Route -> Model -> ( Model, Cmd Msg )
setNewPage maybeRoute model =
    case maybeRoute of
        Just Routes.Home ->
            let
                ( publicFeedModel, publicFeedCmd ) =
                    PublicFeed.init
            in
            ( { model | page = PublicFeed publicFeedModel }
            , Cmd.map PublicFeedMsg publicFeedCmd
            )

        Just Routes.Account ->
            let
                ( accountModel, accountCmd ) =
                    Account.init
            in
            ( { model | page = Account accountModel }
            , Cmd.map AccountMsg accountCmd
            )

        -- START:setNewPage.UserFeed
        Just (Routes.UserFeed username) ->
            let
                ( userFeedModel, userFeedCmd ) =
                    UserFeed.init username
            in
            ( { model | page = UserFeed userFeedModel }
            , Cmd.map UserFeedMsg userFeedCmd
            )
        -- END:setNewPage.UserFeed

        Nothing ->
            ( { model | page = NotFound }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( NewRoute maybeRoute, _ ) ->
            setNewPage maybeRoute model

        ( Visit route, _ ) ->
            ( model, Routes.visit route )

        ( PublicFeedMsg publicFeedMsg, PublicFeed publicFeedModel ) ->
            let
                ( updatedPublicFeedModel, publicFeedCmd ) =
                    PublicFeed.update publicFeedMsg publicFeedModel
            in
            ( { model | page = PublicFeed updatedPublicFeedModel }
            , Cmd.map PublicFeedMsg publicFeedCmd
            )

        ( AccountMsg accountMsg, Account accountModel ) ->
            let
                ( updatedAccountModel, accountCmd ) =
                    Account.update accountMsg accountModel
            in
            ( { model | page = Account updatedAccountModel }
            , Cmd.map AccountMsg accountCmd
            )

        -- START:update.UserFeed
        ( UserFeedMsg userFeedMsg, UserFeed userFeedModel ) ->
            let
                ( updatedUserFeedModel, userFeedCmd ) =
                    UserFeed.update userFeedMsg userFeedModel
            in
            ( { model | page = UserFeed updatedUserFeedModel }
            , Cmd.map UserFeedMsg userFeedCmd
            )
        -- END:update.UserFeed

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.page of
        PublicFeed publicFeedModel ->
            PublicFeed.subscriptions publicFeedModel
                |> Sub.map PublicFeedMsg

        _ ->
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
