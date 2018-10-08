-- START:module
module Routes exposing (Route(..), match)
-- END:module

-- START:import
import Navigation
import UrlParser as Url
-- END:import


-- START:type.Route
type Route
    = Home
    | Account
-- END:type.Route


-- START:match
match : Navigation.Location -> Maybe Route
match location =
    Url.parsePath routes location
-- END:match


-- START:routes
routes : Url.Parser (Route -> a) a
routes =
    Url.oneOf
        [ Url.map Home Url.top
        , Url.map Account (Url.s "account")
        ]
-- END:routes
