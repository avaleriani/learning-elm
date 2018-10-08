module Main exposing (main)

import Browser
import Debug
import Html exposing (Html, text)
import Json.Decode as Decode exposing (Decoder, decodeString, float, int, string)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)



type alias Dog =
    { name : String
    , age : Int
    }


dogDecoder : Decoder Dog
dogDecoder =
    Decode.succeed Dog
       |> required "name" string
       |> required "age" int


jsonDog : String
jsonDog =
    """{
    "name": "cacho"
    ,"age": 3
    }
    """


decodeDog : Result Decode.Error Dog
decodeDog =
    decodeString dogDecoder jsonDog


viewDog : Dog -> Html msg
viewDog dog =
    text <|
        dog.name
            ++ " is "
            ++ String.fromInt dog.age
            ++ " years old."


main : Html msg
main =
    case Debug.log "decodedDog" decodeDog of
        Ok dog ->
            viewDog dog

        Err _ ->
            text "Error: couldn't decode dog"
