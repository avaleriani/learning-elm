module Alias exposing (Id, Model, Photo, Feed)


type alias Photo =
    { id : Int
    , url : String
    , caption : String
    , liked : Bool
    , comments : List String
    , newComment : String
    }


type alias Id =
    Int


type alias Model =
    { feed : Maybe Feed
    }


type alias Feed =
    List Photo
