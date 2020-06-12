module Company.Showroom exposing (..)

import Array
import Color exposing (rgb, toCssString)
import Company.Model exposing (CompanySaveType(..), Model, Msg(..))
import Dict
import Html exposing (Html, div, img, span, text)
import Html.Attributes exposing (class, classList, src, style)
import Html.Events exposing (onClick)
import Model exposing (Card)
import Util exposing (prependMaybe)


renderShowroom : Card -> Model -> Html Msg
renderShowroom card model =
    let
        stateIs state =
            case getStateForCompany model of
                Nothing ->
                    False

                Just s ->
                    s == state
    in
    div [ class "content" ]
        [ div [ class "title" ]
            [ img [ class "navigate-left", src "img/left.svg", onClick PreviousCard ] []
            , div [ class "card-company-name" ] [ text <| Maybe.withDefault "No name" card.name ]
            , img [ class "navigate-right", src "img/right.svg", onClick NextCard ] []
            ]
        , div [ class "card-header" ]
            [ div [ class "card-header-left" ]
                [ div [ class "tag-country-group" ]
                    [ div [ class "card-header-tag" ] [ text <| Maybe.withDefault "No goal specified" card.goal ]
                    ]
                , div [ class "card-company-status" ]
                    [ div [ class "card-flag" ] [ imageForCountry card.country ]
                    , img [ src "img/project.svg" ] []
                    , span [] [ text <| Maybe.withDefault "No stage specified" card.stage ]
                    ]
                ]
            , div [ class "company-logo" ]
                [ img [] [] ]
            ]
        , div [ class "tileslist" ]
            [ div
                [ class "tile-title-value"
                , class "tile"
                , class <| "relevancy-" ++ (String.fromInt <| Maybe.withDefault 50 card.relevancy)
                ]
                [ div [ class "tile-title" ] [ text "Relevancy" ]
                , div [ class "tile-value" ] [ text <| (String.fromInt <| Maybe.withDefault 50 card.relevancy) ]
                ]
            , div [ class "tile-title-value", class "tile" ]
                [ div [ class "tile-title" ] [ text "Diversity %" ]
                , div [ class "tile-value", style "color" <| opennessColor <| Maybe.withDefault 2 card.openness ]
                    [ text <| String.fromInt <| Maybe.withDefault 2 card.openness ]
                ]
            ]
        , div [ class "tileslist" ]
            [ tileForFinancials card
            , tileForAchievements card
            ]
        , div [ class "sector" ] [ text <| Maybe.withDefault "Industry not specified" card.industry ]
        , div [ class "summary" ] [ text <| Maybe.withDefault "No description" card.description ]
        , div [ class "card-action" ]
            [ div
                [ onClick DislikeCompany
                , classList [ ( "active", stateIs Reject ) ]
                ]
                [ img [ src "img/reject.svg" ] [] ]
            , div
                [ onClick SaveCompany
                , classList [ ( "active", stateIs Save ) ]
                ]
                [ img [ src "img/save.svg" ] [] ]
            , div
                [ onClick LikeCompany
                , classList [ ( "active", stateIs Like ) ]
                ]
                [ img [ src "img/heart.svg" ] [] ]
            ]
        ]


getStateForCompany : Model -> Maybe CompanySaveType
getStateForCompany model =
    Array.get model.activeCard model.cards
        |> Maybe.andThen .id
        |> Maybe.andThen (getStateForId model.save)


getStateForId dict id =
    Dict.get id dict


imageForCountry _ =
    img [ src "img/DE.svg" ] []


tileForFinancials : Card -> Html msg
tileForFinancials card =
    [ ( "img/tag.svg", [ Maybe.withDefault "Unknown" card.investor ] )
    , ( "img/money.svg"
      , [ "Last funding"
        , Maybe.withDefault "Unknown" card.funding
        , Maybe.withDefault "Unknown" card.fundingDate
        ]
      )
    ]
        |> iconTextToTile


tileForAchievements : Card -> Html msg
tileForAchievements card =
    []
        |> prependMaybe card.award3
        |> prependMaybe card.award2
        |> prependMaybe card.award1
        |> List.map (\a -> ( "img/badge.svg", [ a ] ))
        |> iconTextToTile


iconTextToTile : List ( String, List String ) -> Html msg
iconTextToTile items =
    let
        content =
            items
                |> List.map
                    (\( icon, textContent ) ->
                        div [ class "tile-iconrow" ]
                            [ img [ class "icon", src icon ] []
                            , div [ class "text" ]
                                (List.map (\t -> div [] [ text t ]) textContent)
                            ]
                    )
    in
    div [ class "tile-icon-text", class "tile" ] content


deltaR =
    1.45


deltaG =
    1.58


deltaB =
    1.71


baseR =
    145.0


baseG =
    172.0


baseB =
    205.0


opennessColor : Int -> String
opennessColor value =
    let
        vf =
            toFloat value

        r =
            (baseR - vf * deltaR) / 255

        g =
            (baseG - vf * deltaG) / 255

        b =
            (baseB - vf * deltaB) / 255

        color =
            rgb r g b
    in
    toCssString color
