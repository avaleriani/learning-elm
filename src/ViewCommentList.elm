module ViewCommentList exposing (viewCommentList, viewComments)

import Alias exposing (..)
import Html exposing (Html, button, div, form, input, text, ul)
import Html.Attributes exposing (class, placeholder, type_, value, disabled)
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


viewComments : Model -> Html Msg
viewComments model =
    div []
        [ viewCommentList model.comments
        , form [ class "new-comment"
        ,onSubmit Types.SaveComment]
            [ input
                [ type_ "text"
                , placeholder "Add new comment"
                , value model.newComment
                , onInput Types.UpdateComment
                ]
                []
            , button [ disabled (String.isEmpty model.newComment)] [ text "Save" ]
            ]
        ]
