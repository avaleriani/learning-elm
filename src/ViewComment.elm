module ViewComment exposing (viewComment)

import Alias exposing (..)
import Html exposing (Html, li, strong, text)
import Html.Attributes exposing (class, placeholder, type_)
import Types exposing (..)


viewComment : String -> Html Msg
viewComment comment =
    li []
        [ strong [] [ text "Comment:" ]
        , text (" " ++ comment)
        ]
