module ViewCommentList exposing (..)

import Html exposing (Html, text, ul, text, div, form, input)
import Html.Attributes exposing (type_, class, placeholder)
import Types exposing (..)
import Alias exposing (..)


viewCommentList: List String -> Html Msg
viewCommentList comments =
        case comments of
            [] ->
                text ""

             _ ->
                div [class "comments"]
                 [ ul []
                    (List.map viewComment comments)
                 ]

viewComments: Model -> Html Msg
viewComments model =
    div []
    [ viewCommentList model.comments
    , form [ class "new-comment" ]
        [input
            [type_ "text"
            ,placeholder "Add new comment"
            ]
            []
        ,button [] [text "Save"]
        ]