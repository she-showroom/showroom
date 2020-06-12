module Company.Financials exposing (..)

import Company.Util exposing (cardHeader)
import Html exposing (Html, div, img, text)
import Html.Attributes exposing (class, src)
import Model exposing (Card)
import Svg exposing (line, polyline, svg)
import Svg.Attributes exposing (d, fill, height, points, stroke, strokeWidth, viewBox, width)


renderFinancials : Card -> Html msg
renderFinancials card =
    cardHeader (Maybe.withDefault "No Name" card.name) <|
        div [ class "card-sub" ]
            [ div [ class "title" ] [ text "Projected YoY Growth (est.)" ]
            , svgPlot
            , div [ class "title" ] [ text "Total projected gross revenue" ]
            , div [ class "number" ] [ text "$3,000,000" ]
            , div [ class "title" ] [ text "Total projected ??" ]
            , div [ class "number" ] [ text "$2,000,000" ]
            ]


svgPlot =
    div [ class "svg-container" ]
        [ svg [ width "100%", height "200px", viewBox "0 0 300 100" ]
            [ polyline
                [ fill "none"
                , stroke "#F0EBD8"
                , strokeWidth "3px"
                , points "0,65 300,65"
                ]
                []
            , polyline
                [ fill "none"
                , stroke "#748CAB"
                , strokeWidth "3px"
                , points "0,100 60,75 180,55 300,0"
                ]
                []
            , polyline
                [ fill "none"
                , stroke "black"
                , strokeWidth "3px"
                , points "0,65 300,10"
                ]
                []
            ]
        ]
