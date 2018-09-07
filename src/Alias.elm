module Alias exposing (..)

type alias Model = {
    url: String
    , caption: String
    , liked: Bool
    , comments: List String
    , newComment: String
    }
