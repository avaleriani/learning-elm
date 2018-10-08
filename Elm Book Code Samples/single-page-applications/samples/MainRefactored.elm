module Main exposing (main)

import Account
import Html exposing (Html, a, div, h1, i, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Navigation
import PublicFeed
import Routes
import UserFeed


---- MODEL ----


type Page
    = PublicFeed PublicFeed.Model
    | Account Account.Model
    | UserFeed UserFeed.Model
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

        UserFeed userFeedModel ->
            UserFeed.view userFeedModel
                |> Html.map UserFeedMsg

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


type Msg
    = NewRoute (Maybe Routes.Route)
    | Visit Routes.Route
    | PublicFeedMsg PublicFeed.Msg
    | AccountMsg Account.Msg
    | UserFeedMsg UserFeed.Msg


processPageUpdate :
    (pageModel -> Page)
    -> (pageMsg -> Msg)
    -> Model
    -> ( pageModel, Cmd pageMsg )
    -> ( Model, Cmd Msg )
processPageUpdate createPage wrapMsg model ( pageModel, pageCmd ) =
    ( { model | page = createPage pageModel }
    , Cmd.map wrapMsg pageCmd
    )


setNewPage : Maybe Routes.Route -> Model -> ( Model, Cmd Msg )
setNewPage maybeRoute model =
    case maybeRoute of
        Just Routes.Home ->
            PublicFeed.init
                |> processPageUpdate PublicFeed PublicFeedMsg model

        Just Routes.Account ->
            Account.init
                |> processPageUpdate Account AccountMsg model

        Just (Routes.UserFeed username) ->
            UserFeed.init username
                |> processPageUpdate UserFeed UserFeedMsg model

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
            PublicFeed.update publicFeedMsg publicFeedModel
                |> processPageUpdate PublicFeed PublicFeedMsg model

        ( AccountMsg accountMsg, Account accountModel ) ->
            Account.update accountMsg accountModel
                |> processPageUpdate Account AccountMsg model

        ( UserFeedMsg userFeedMsg, UserFeed userFeedModel ) ->
            UserFeed.update userFeedMsg userFeedModel
                |> processPageUpdate UserFeed UserFeedMsg model

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
