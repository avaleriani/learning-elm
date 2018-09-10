module ViewCommentList exposing (viewCommentList, viewComments)

import Alias exposing (..)
import Html exposing (Html, button, div, form, input, text, ul)
import Html.Attributes exposing (class, disabled, placeholder, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Types exposing (..)
import ViewComment exposing (..)


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
        , form
            [ class "new-comment"

            --        ,onSubmit Types.SaveComment
            ]
            [ input
                [ type_ "text"
                , placeholder "Add new comment"
                , value photo.newComment

                --                , onInput Types.UpdateComment
                ]
                []
            , button [ disabled (String.isEmpty photo.newComment) ] [ text "Save" ]
            ]
        ]
