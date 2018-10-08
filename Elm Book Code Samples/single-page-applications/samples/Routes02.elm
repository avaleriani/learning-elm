-- START:module
module Routes exposing (Route(..), match, routeToUrl, visit)
-- END:module

import Navigation
import UrlParser as Url


type Route
    = Home
    | Account


match : Navigation.Location -> Maybe Route
match location =
    Url.parsePath routes location


-- START:visit
visit : Route -> Cmd msg
visit route =
    routeToUrl route
        |> Navigation.newUrl
-- END:visit


-- START:routeToUrl
routeToUrl : Route -> String
routeToUrl route =
    case route of
        Home ->
            "/"

        Account ->
            "/account"
-- END:routeToUrl


routes : Url.Parser (Route -> a) a
routes =
    Url.oneOf
        [ Url.map Home Url.top
        , Url.map Account (Url.s "account")
        ]
