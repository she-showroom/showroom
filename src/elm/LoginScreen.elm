module LoginScreen exposing (view)

import Html exposing (Html, a, div, input, text)
import Html.Attributes exposing (class, href, placeholder)


view : Html msg
view =
    div [ class "login" ]
        [ div [ class "logo" ] [ text "<logo>" ]
        , input [ placeholder "Search" ] []
        , a [ class "register", href "/register" ] [ div [] [ text "Register a COVID startup" ] ]
        , a [ class "join", href "/company" ] [ div [] [ text "Join as a user" ] ]
        ]
