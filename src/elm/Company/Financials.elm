module Company.Financials exposing (..)

import Company.Util exposing (cardHeader)
import Html exposing (Html, div, img, text)
import Html.Attributes exposing (class, src)
import Model exposing (Card)
import Svg exposing (line, polyline, svg, text_)
import Svg.Attributes exposing (color, fill, fontSize, fontWeight, height, points, stroke, strokeWidth, viewBox, width, x, x1, x2, y, y1, y2)


renderFinancials : Card -> Html msg
renderFinancials card =
    cardHeader (Maybe.withDefault "No Name" card.name) <|
        div [ class "card-sub" ]
            [ div [ class "title" ] [ text "Projected YoY Growth (est.)" ]
            , svgPlot
            , div [ class "title" ] [ text "Total projected gross revenue" ]
            , div [ class "number" ] [ text "$3,000,000" ]
            , div [ class "title" ] [ text "Total projected team size" ]
            , div [ class "number" ] [ text "47" ]
            , div [ class "downarrow" ]
                [ div [ class "box" ]
                    [ img [ src "img/down.svg" ] []
                    , div [ class "tooltip" ] [ text "Detailed financial statements in v.2" ]
                    ]
                ]
            ]


svgPlot =
    div [ class "svg-container" ]
        [ svg [ viewBox "0 0 300 135", fontSize "10px" ]
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
            , text_ [ x "20", y "110" ] [ text "Year 1" ]
            , text_ [ x "70", y "110" ] [ text "Year 2" ]
            , text_ [ x "120", y "110" ] [ text "Year 3" ]
            , text_ [ x "170", y "110" ] [ text "Year 4" ]
            , text_ [ x "230", y "110" ] [ text "Year 5" ]
            , line
                [ x1 "75"
                , y1 "130"
                , x2 "90"
                , y2 "130"
                , stroke "#748CAB"
                , strokeWidth "3px"
                ]
                []
            , text_
                [ x "94"
                , y "134"
                , fill "#748CAB"
                , fontSize "12px"
                ]
                [ text "Revenue" ]
            , line
                [ x1 "165"
                , y1 "130"
                , x2 "180"
                , y2 "130"
                , stroke "#3E5C76"
                , strokeWidth "3px"
                ]
                []
            , text_
                [ x "185"
                , y "134"
                , fill "#3E5C76"
                , fontSize "12px"
                ]
                [ text "Team" ]
            ]
        ]
