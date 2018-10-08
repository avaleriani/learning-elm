module Main exposing (main)

import Account
-- START:import.Feed
import Feed as PublicFeed
-- END:import.Feed
import Html exposing (Html, a, div, h1, i, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Navigation
import Routes


---- MODEL ----


type Page
    -- START:type.Page.PublicFeed
    = PublicFeed PublicFeed.Model
    -- END:type.Page.PublicFeed
    | Account Account.Model
    | NotFound


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
            -- START:viewHeader.anchors
            [ a [ class "nav-brand", onClick (Visit Routes.Home) ]
                [ text "Picshare" ]
            , a [ class "nav-account", onClick (Visit Routes.Account) ]
                [ i [ class "fa fa-2x fa-gear" ] [] ]
            ]
            -- END:viewHeader.anchors
        ]


viewContent : Page -> Html Msg
viewContent page =
    case page of
        -- START:viewContent.PublicFeed
        PublicFeed publicFeedModel ->
            PublicFeed.view publicFeedModel
                |> Html.map PublicFeedMsg
        -- END:viewContent.PublicFeed

        Account accountModel ->
            Account.view accountModel
                |> Html.map AccountMsg

        NotFound ->
            div [ class "not-found" ]
                [ h1 [] [ text "Page Not Found" ] ]


view : Model -> Html Msg
-- START:view
view model =
    div []
        [ viewHeader
        , viewContent model.page
        ]
-- END:view



---- UPDATE ----


type Msg
    = NewRoute (Maybe Routes.Route)
    -- START:type.Msg.Visit
    | Visit Routes.Route
    -- END:type.Msg.Visit
    -- START:type.Msg.PublicFeedMsg
    | PublicFeedMsg PublicFeed.Msg
    -- END:type.Msg.PublicFeedMsg
    | AccountMsg Account.Msg


setNewPage : Maybe Routes.Route -> Model -> ( Model, Cmd Msg )
setNewPage maybeRoute model =
    case maybeRoute of
        -- START:setNewPage.routes.Home
        Just Routes.Home ->
            let
                ( publicFeedModel, publicFeedCmd ) =
                    PublicFeed.init
            in
            ( { model | page = PublicFeed publicFeedModel }
            , Cmd.map PublicFeedMsg publicFeedCmd
            )
        -- END:setNewPage.routes.Home

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
update msg model =
    case ( msg, model.page ) of
        ( NewRoute maybeRoute, _ ) ->
            setNewPage maybeRoute model

        -- START:update.Visit
        ( Visit route, _ ) ->
            ( model, Routes.visit route )
        -- END:update.Visit

        -- START:update.PublicFeed
        ( PublicFeedMsg publicFeedMsg, PublicFeed publicFeedModel ) ->
            let
                ( updatedPublicFeedModel, publicFeedCmd ) =
                    PublicFeed.update publicFeedMsg publicFeedModel
            in
            ( { model | page = PublicFeed updatedPublicFeedModel }
            , Cmd.map PublicFeedMsg publicFeedCmd
            )
        -- END:update.PublicFeed

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


subscriptions : Model -> Sub Msg
-- START:subscriptions
subscriptions model =
    case model.page of
        PublicFeed publicFeedModel ->
            PublicFeed.subscriptions publicFeedModel
                |> Sub.map PublicFeedMsg

        _ ->
            Sub.none
-- END:subscriptions



---- PROGRAM ----


main : Program Never Model Msg
main =
    Navigation.program (Routes.match >> NewRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
