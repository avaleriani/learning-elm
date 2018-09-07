module ViewPhotoDetail exposing (viewPhotoDetail)

import Alias exposing (Model)
import Html exposing (Html, div, h2, i, img, text)
import Html.Attributes exposing (class, src)
import Types exposing (Msg)
import ViewCommentList exposing (..)
import ViewLoveButton exposing (..)


viewPhotoDetail : Model -> Html Msg
viewPhotoDetail model =
    div [ class "photo" ]
        [ img [ src model.url ] []
        , div [ class "photo-info" ]
            [ viewLoveButton model
            , h2 [ class "caption" ] [ text model.caption ]
            , viewComments model
            ]
        ]
