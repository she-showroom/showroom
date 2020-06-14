module Company.Saved exposing (..)

import Array exposing (Array)
import Company.Model exposing (CompanySaveType(..), Model)
import Company.Util exposing (cardHeader)
import Dict exposing (Dict)
import Html exposing (Html, div, img, input, table, td, text, th, tr)
import Html.Attributes exposing (class, src)
import Model exposing (Card)


type alias SavedList =
    { relevancy : Int
    , stage : String
    , name : String
    }


saved : Model -> List ( CompanySaveType, Card )
saved model =
    model.cards
        |> Array.map (\card -> ( Like, card ))
        |> Array.map (\( _, card ) -> ( getMatchingCompanySaveType model.save card.id, card ))
        |> Array.filter
            (\( s, _ ) ->
                case s of
                    Nothing ->
                        False

                    Just save ->
                        case save of
                            Reject ->
                                False

                            _ ->
                                True
            )
        |> Array.map
            (\( s, c ) ->
                case s of
                    Nothing ->
                        ( Like, c )

                    Just save ->
                        ( save, c )
            )
        |> Array.toList


getMatchingCompanySaveType : Dict String CompanySaveType -> Maybe String -> Maybe CompanySaveType
getMatchingCompanySaveType dict key =
    case key of
        Nothing ->
            Nothing

        Just k ->
            Dict.get k dict


renderSaved : Card -> Model -> Html msg
renderSaved card model =
    cardHeader "Saved Projects" <|
        div [ class "card-sub" ]
            [ div [ class "financials" ]
                [ div [ class "filter" ]
                    [ div [ class "input" ]
                        [ div [] [ text "Filter" ], img [ src "img/search.svg" ] [] ]
                    ]
                , div [ class "list-container" ]
                    [ table [ class "list" ]
                        (tr [ class "titles" ]
                            [ th [] []
                            , th [] [ text "Relevancy" ]
                            , th [] [ text "Stage" ]
                            , th [] [ text "Name" ]
                            ]
                            :: (saved model |> List.map renderRow)
                        )
                    ]
                , div [ class "similar" ] [ text "Activate Similar Projects" ]
                ]
            ]


renderRow : ( CompanySaveType, Card ) -> Html msg
renderRow ( saveType, card ) =
    tr [ class "row" ]
        [ td [ class "img-save" ] [ imgForSaveType saveType ]
        , td [ class "relevancy" ]
            [ div [] [ div [ class "rel-button" ] [ text <| String.fromInt (Maybe.withDefault 0 card.relevancy) ] ] ]
        , td [ class "stage" ]
            [ div []
                [ img [ src "img/project.svg" ] [], text (Maybe.withDefault "" card.stage) ]
            ]
        , td [ class "name" ] [ text (Maybe.withDefault "" card.name) ]
        ]


imgForSaveType : CompanySaveType -> Html msg
imgForSaveType savetype =
    let
        file =
            case savetype of
                Like ->
                    "img/heart.svg"

                Save ->
                    "img/save.svg"

                Reject ->
                    "img/reject.svg"
    in
    img [ src file ] []
