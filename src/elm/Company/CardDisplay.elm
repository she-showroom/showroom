module Company.CardDisplay exposing (..)

import Array exposing (Array)
import Color exposing (rgb, toCssString)
import Company.Chat exposing (renderChat)
import Company.Financials exposing (renderFinancials)
import Company.Model exposing (CompanySaveType(..), Model, Msg(..), State(..))
import Company.Saved exposing (renderSaved)
import Company.Showroom exposing (renderShowroom)
import Dict exposing (Dict)
import Html exposing (Html, div, img, span, text)
import Html.Attributes exposing (class, classList, src, style)
import Html.Events exposing (onClick)
import Model exposing (Card)


newCardModel : Array Card -> Model
newCardModel cards =
    { cards = cards
    , activeCard = 0
    , state = Showroom
    , save = Dict.empty
    }


view : Model -> Html Msg
view model =
    let
        card =
            Array.get model.activeCard model.cards

        blueBackground =
            case model.state of
                Showroom ->
                    False

                _ ->
                    True

        content =
            case card of
                Nothing ->
                    div [] []

                Just c ->
                    case model.state of
                        Showroom ->
                            renderShowroom c model

                        Financials ->
                            renderFinancials c

                        Saved ->
                            renderSaved c model

                        Chat ->
                            renderChat c model

        menuItemSelection =
            menuItem model
    in
    div [ class "card-display" ]
        [ div [ class "card", classList [ ( "blue-background", blueBackground ) ] ]
            [ content
            ]
        , div [ class "menu" ]
            [ menuItemSelection Showroom "menu-showroom" "Showroom"
            , menuItemSelection Financials "menu-financials" "Financials"
            , menuItemSelection Saved "menu-similar" "Similar"
            , menuItemSelection Chat "menu-chat" "Chat"
            ]
        ]


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        PreviousCard ->
            ( { model | activeCard = previousCard model.activeCard model.cards }, Cmd.none )

        NextCard ->
            ( { model | activeCard = nextCard model.activeCard model.cards }, Cmd.none )

        SetState state ->
            ( { model | state = state }, Cmd.none )

        LikeCompany ->
            let
                newDict =
                    saveSaveForCurrentCompany model Like |> Maybe.withDefault model.save
            in
            ( { model | save = newDict }, Cmd.none )

        DislikeCompany ->
            let
                newDict =
                    saveSaveForCurrentCompany model Reject |> Maybe.withDefault model.save
            in
            ( { model | save = newDict }, Cmd.none )

        SaveCompany ->
            let
                newDict =
                    saveSaveForCurrentCompany model Save |> Maybe.withDefault model.save
            in
            ( { model | save = newDict }, Cmd.none )


saveSaveForCurrentCompany : Model -> CompanySaveType -> Maybe (Dict String CompanySaveType)
saveSaveForCurrentCompany model value =
    Array.get model.activeCard model.cards
        |> Maybe.andThen .id
        |> Maybe.map (\id -> saveSaveForId model.save value id)


saveSaveForId : Dict String CompanySaveType -> CompanySaveType -> String -> Dict String CompanySaveType
saveSaveForId dict value id =
    Dict.insert id value dict



--getStateForCompany : Int -> Array Card -> List CompanySave -> Maybe CompanySaveType
--getStateForCompany selection cards saves =
--    Array.get selection cards
--        |> Maybe.andThen .id
--        |> Maybe.andThen (companySaveForId saves)
--
--
--companySaveForId : List CompanySave -> String -> Maybe CompanySaveType
--companySaveForId saves id =
--    saves
--        |> List.filter (\s -> s.id == id)
--        |> List.head
--        |> Maybe.map .saveResult


previousCard : Int -> Array Card -> Int
previousCard card cards =
    if card == 0 then
        Array.length cards - 1

    else
        card - 1


nextCard : Int -> Array Card -> Int
nextCard card cards =
    if card == Array.length cards - 1 then
        0

    else
        card + 1


isShowroom model =
    case model.state of
        Showroom ->
            True

        _ ->
            False


isFinancials model =
    case model.state of
        _ ->
            False


isSimilar model =
    case model.state of
        _ ->
            False


isChat model =
    case model.state of
        _ ->
            False


menuItem : Model -> State -> String -> String -> Html Msg
menuItem model state icon name =
    let
        enabled =
            model.state == state
    in
    div [ class "item", classList [ ( "enabled", enabled ) ], onClick <| SetState state ]
        [ div [ class "icon", class icon ] []
        , div [] [ text name ]
        ]
