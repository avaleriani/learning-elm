module Feed exposing (Model, Msg, init, subscriptions, update, view)

import Html exposing (..)
import Html.Attributes exposing (class, disabled, placeholder, src, type_, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Http
import Json.Decode exposing (Decoder, bool, decodeString, int, list, string)
import Json.Decode.Pipeline exposing (decode, hardcoded, required)
-- START:import.Routes
import Routes
-- END:import.Routes
import WebSocket


type alias Id =
    Int


-- START:type.Photo
type alias Photo =
    { id : Id
    , url : String
    , caption : String
    , liked : Bool
    , comments : List String
    , username : String
    , newComment : String
    }
-- END:type.Photo


type alias Feed =
    List Photo


type alias Model =
    { feed : Maybe Feed
    , error : Maybe Http.Error
    , streamQueue : Feed
    }


photoDecoder : Decoder Photo
-- START:photoDecoder
photoDecoder =
    decode Photo
        |> required "id" int
        |> required "url" string
        |> required "caption" string
        |> required "liked" bool
        |> required "comments" (list string)
        |> required "username" string
        |> hardcoded ""
-- END:photoDecoder


initialModel : Model
initialModel =
    { feed = Nothing
    , error = Nothing
    , streamQueue = []
    }


-- START:init
init : String -> ( Model, Cmd Msg )
init url =
    ( initialModel, fetchFeed url )
-- END:init


-- START:fetchFeed
fetchFeed : String -> Cmd Msg
fetchFeed url =
    Http.get url (list photoDecoder)
        |> Http.send LoadFeed
-- END:fetchFeed


viewLoveButton : Photo -> Html Msg
viewLoveButton photo =
    let
        buttonClass =
            if photo.liked then
                "fa-heart"
            else
                "fa-heart-o"
    in
    div [ class "like-button" ]
        [ i
            [ class "fa fa-2x"
            , class buttonClass
            , onClick (ToggleLike photo.id)
            ]
            []
        ]


viewComment : String -> Html Msg
viewComment comment =
    li []
        [ strong [] [ text "Comment:" ]
        , text (" " ++ comment)
        ]


viewCommentList : List String -> Html Msg
viewCommentList comments =
    case comments of
        [] ->
            text ""

        _ ->
            div [ class "comments" ]
                [ ul []
                    (List.map viewComment comments)
                ]


viewComments : Photo -> Html Msg
viewComments photo =
    div []
        [ viewCommentList photo.comments
        , form [ class "new-comment", onSubmit (SaveComment photo.id) ]
            [ input
                [ type_ "text"
                , placeholder "Add a comment..."
                , value photo.newComment
                , onInput (UpdateComment photo.id)
                ]
                []
            , button
                [ disabled (String.isEmpty photo.newComment) ]
                [ text "Save" ]
            ]
        ]


viewDetailedPhoto : Photo -> Html Msg
viewDetailedPhoto photo =
    div [ class "detailed-photo" ]
        [ img [ src photo.url ] []
        , div [ class "photo-info" ]
            [ viewLoveButton photo
            , h2 [ class "caption" ] [ text photo.caption ]
            , h3 [ class "username" ]
                -- START:viewDetailedPhoto.username.anchor
                [ a [ onClick (Visit (Routes.UserFeed photo.username)) ]
                    [ text ("@" ++ photo.username) ]
                ]
                -- END:viewDetailedPhoto.username.anchor
            , viewComments photo
            ]
        ]


viewFeed : Maybe Feed -> Html Msg
viewFeed maybeFeed =
    case maybeFeed of
        Just feed ->
            div [] (List.map viewDetailedPhoto feed)

        Nothing ->
            div [ class "loading-feed" ]
                [ text "Loading Feed..." ]


errorMessage : Http.Error -> String
errorMessage error =
    case error of
        Http.BadPayload _ _ ->
            """Sorry, we couldn't process your feed at this time.
            We're working on it!"""

        _ ->
            """Sorry, we couldn't load your feed at this time.
            Please try again later."""


viewStreamNotification : Feed -> Html Msg
viewStreamNotification queue =
    case queue of
        [] ->
            text ""

        _ ->
            let
                content =
                    "View new photos: "
                        ++ toString (List.length queue)
            in
            div
                [ class "stream-notification"
                , onClick FlushStreamQueue
                ]
                [ text content ]


viewContent : Model -> Html Msg
viewContent model =
    case model.error of
        Just error ->
            div [ class "feed-error" ]
                [ text (errorMessage error) ]

        Nothing ->
            div []
                [ viewStreamNotification model.streamQueue
                , viewFeed model.feed
                ]


view : Model -> Html Msg
view model =
-- START:view
    div []
        [ div [ class "content-flow" ]
            [ viewContent model ]
        ]
-- END:view


type Msg
    = ToggleLike Id
    | UpdateComment Id String
    | SaveComment Id
    | LoadFeed (Result Http.Error Feed)
    | LoadStreamPhoto (Result String Photo)
    | FlushStreamQueue
    -- START:type.Msg.Visit
    | Visit Routes.Route
    -- END:type.Msg.Visit


saveNewComment : Photo -> Photo
saveNewComment photo =
    let
        comment =
            String.trim photo.newComment
    in
    case comment of
        "" ->
            photo

        _ ->
            { photo
                | comments = photo.comments ++ [ comment ]
                , newComment = ""
            }


toggleLike : Photo -> Photo
toggleLike photo =
    { photo | liked = not photo.liked }


updateComment : String -> Photo -> Photo
updateComment comment photo =
    { photo | newComment = comment }


updatePhotoById : (Photo -> Photo) -> Id -> Feed -> Feed
updatePhotoById updatePhoto id feed =
    List.map
        (\photo ->
            if photo.id == id then
                updatePhoto photo
            else
                photo
        )
        feed


updateFeed : (Photo -> Photo) -> Id -> Maybe Feed -> Maybe Feed
updateFeed updatePhoto id maybeFeed =
    Maybe.map (updatePhotoById updatePhoto id) maybeFeed


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleLike id ->
            ( { model
                | feed = updateFeed toggleLike id model.feed
              }
            , Cmd.none
            )

        UpdateComment id comment ->
            ( { model
                | feed = updateFeed (updateComment comment) id model.feed
              }
            , Cmd.none
            )

        SaveComment id ->
            ( { model
                | feed = updateFeed saveNewComment id model.feed
              }
            , Cmd.none
            )

        LoadFeed (Ok feed) ->
            ( { model | feed = Just feed }
            , Cmd.none
            )

        LoadFeed (Err error) ->
            ( { model | error = Just error }, Cmd.none )

        LoadStreamPhoto (Ok photo) ->
            ( { model | streamQueue = photo :: model.streamQueue }
            , Cmd.none
            )

        LoadStreamPhoto (Err _) ->
            ( model, Cmd.none )

        FlushStreamQueue ->
            ( { model
                | feed = Maybe.map ((++) model.streamQueue) model.feed
                , streamQueue = []
              }
            , Cmd.none
            )

        -- START:update.Visit
        Visit route ->
            ( model, Routes.visit route )
        -- END:update.Visit


-- START:subscriptions
subscriptions : String -> Model -> Sub Msg
subscriptions url model =
    case model.feed of
        Just _ ->
            WebSocket.listen url
                (LoadStreamPhoto << decodeString photoDecoder)

        Nothing ->
            Sub.none
-- END:subscriptions