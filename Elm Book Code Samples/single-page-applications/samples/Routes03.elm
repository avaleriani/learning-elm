module Routes exposing (Route(..), match, routeToUrl, visit)

import Navigation
-- START:import.UrlParser
import UrlParser as Url exposing ((</>))
-- END:import.UrlParser


-- START:type.Route
type Route
    = Home
    | Account
    | UserFeed String
-- END:type.Route


match : Navigation.Location -> Maybe Route
match location =
    Url.parsePath routes location


visit : Route -> Cmd msg
visit route =
    routeToUrl route
        |> Navigation.newUrl


routeToUrl : Route -> String
routeToUrl route =
    case route of
        Home ->
            "/"

        Account ->
            "/account"

        -- START:routeToUrl.UserFeed
        UserFeed username ->
            "/user/" ++ username ++ "/feed"
        -- END:routeToUrl.UserFeed


routes : Url.Parser (Route -> a) a
-- START:routes
routes =
    Url.oneOf
        [ Url.map Home Url.top
        , Url.map Account (Url.s "account")
        , Url.map UserFeed (Url.s "user" </> Url.string </> Url.s "feed")
        ]
-- END:routes
