module Company.Util exposing (..)

import Html exposing (div, img, text)
import Html.Attributes exposing (class, src)


cardHeader title content =
    div [ class "blue-card-header" ]
        [ div [ class "image" ] [ img [ src "img/title.png" ] [] ]
        , div [ class "title-row" ] [ div [] [ text title ], img [ src "img/user.svg" ] [], img [ src "img/wheel.svg" ] [] ]
        , content
        ]
