module Types exposing (Msg(..))

import Alias exposing (..)
import Http

type Msg
    = ToggleLike
    | UpdateComment String
    | SaveComment
    | LoadFeed (Result Http.Error Feed)
