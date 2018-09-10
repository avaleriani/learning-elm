module ViewPhotoDetail exposing (viewPhotoDetail)

import Alias exposing (Photo)
import Html exposing (Html, div, h2, i, img, text)
import Html.Attributes exposing (class, src)
import Types exposing (Msg)
import ViewCommentList exposing (..)
import ViewLoveButton exposing (..)


viewPhotoDetail : Photo -> Html Msg
viewPhotoDetail photo =
    div [ class "photo" ]
        [ img [ src photo.url ] []
        , div [ class "photo-info" ]
            [ viewLoveButton photo
            , h2 [ class "caption" ] [ text photo.caption ]
            , viewComments photo
            ]
        ]
