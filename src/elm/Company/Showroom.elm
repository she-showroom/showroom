module Company.Showroom exposing (..)

import Array
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
    div [ class "showroom-container" ]
        [ div [ class "showroom" ]
            [ div [ class "title" ]
                [ img [ class "navigate-left", src "img/left.svg", onClick PreviousCard ] []
                , div [ class "card-company-name" ] [ text <| Maybe.withDefault "No name" card.name ]
                , img [ class "navigate-right", src "img/right.svg", onClick NextCard ] []
                ]
            , div [ class "scroll" ]
                [ div [ class "card-header" ]
                    [ div [ class "card-header-left" ]
                        [ div [ class "sector" ] [ text <| Maybe.withDefault "Industry not specified" card.industry ]
                        , div [ class "summary" ] [ text <| Maybe.withDefault "No description" card.description ]
                        ]
                    , div [ class "company-logo" ]
                        [ img [ src "img/checker.png" ] [] ]
                    ]
                , div [ class "focus" ]
                    [ div [ style "font-weight" "bold" ] [ text "Innovation focus: " ]
                    , div [] [ text <| Maybe.withDefault "Unknown" card.focus ]
                    ]
                , div [ class "card-company-status" ]
                    [ div [ class "card-flag" ] [ imageForCountry card.country ]
                    , div [ class "status" ]
                        [ img [ src "img/project.svg" ] []
                        , span [] [ text <| Maybe.withDefault "No stage specified" card.stage ]
                        ]
                    , div [ class "card-header-tag" ] [ text <| Maybe.withDefault "No goal specified" card.goal ]
                    ]
                , div [ class "tileslist" ]
                    [ div
                        [ class "tile-title-value"
                        , class "tile"
                        , class <| "relevancy-" ++ (String.fromInt <| Maybe.withDefault 50 card.relevancy)
                        ]
                        [ div [ class "tile-title" ] [ text "Relevancy" ]
                        , div [ class "tile-value" ]
                            [ span [ class "value" ] [ text <| (String.fromInt <| Maybe.withDefault 50 card.relevancy) ]
                            , span [ class "base" ] [ text "/5" ]
                            ]
                        ]
                    , tileForChecklist card
                    ]
                , div [ class "tileslist" ]
                    [ tileForFinancials card
                    , tileForAchievements card
                    ]
                ]
            ]
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


tileForChecklist : Card -> Html msg
tileForChecklist card =
    List.map (\check -> ( "img/check.svg", [ check ] )) card.checklist
        |> iconTextToTile


tileForFinancials : Card -> Html msg
tileForFinancials card =
    [ ( "img/tag.svg", [ Maybe.withDefault "Unknown" card.investor, "" ] )
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
                        let
                            isMultiline =
                                List.length textContent > 1
                        in
                        div [ class "tile-iconrow", classList [ ( "multiline", isMultiline ) ] ]
                            [ img [ class "icon", src icon ] []
                            , div [ class "text" ]
                                (List.map (\t -> div [] [ text t ]) textContent)
                            ]
                    )
    in
    div [ class "tile-icon-text", class "tile" ] content
