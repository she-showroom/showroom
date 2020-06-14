port module Main exposing (main)

import Array exposing (Array)
import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav exposing (Key)
import Company.CardDisplay as CardDisplay
import Company.Model exposing (Msg(..))
import Html exposing (div, text)
import LoginScreen
import Model exposing (Card)
import Registration exposing (Msg(..), newRegistration)
import Swiper
import Url exposing (Url)


port getCards : () -> Cmd msg


port saveCard : Card -> Cmd msg


port cardsReceiver : (Array Card -> msg) -> Sub msg


type alias SaveResult =
    { success : Bool
    , message : String
    }


port cardSaved : (SaveResult -> msg) -> Sub msg



-- type alias Country =
--     { name : String
--     , flag : String
--     }


type State
    = LoginScreen
    | Loading
    | Cards Company.Model.Model
      -- | NoCards
    | RegistrationScreen Registration.RegistrationData


type alias Model =
    { key : Key
    , state : State
    , swipingState : Swiper.SwipingState
    , userSwipedLeft : Bool
    }


type Msg
    = NewCards (Array Card)
    | Swiped Swiper.SwipeEvent
      -- | SwitchToPage State
    | ChangeUrl Url
    | ClickLink UrlRequest
    | RegistrationMessage Registration.Msg
    | CardMessage Company.Model.Msg
    | CardSaved SaveResult


type alias Flags =
    ()


init : Flags -> Url -> Key -> ( Model, Cmd msg )
init _ url key =
    let
        ( state, cmd ) =
            stateFromUrl url.path
    in
    ( Model key state Swiper.initialSwipingState False, cmd )


stateFromUrl : String -> ( State, Cmd msg )
stateFromUrl url =
    case url of
        --"/login" ->
        --    ( LoginScreen, Cmd.none )
        --"/company" ->
        --    ( Loading, getCards () )
        --"/register" ->
        --    ( RegistrationScreen newRegistration, Cmd.none )
        _ ->
            ( Loading, getCards () )


titleFromState : State -> String
titleFromState state =
    case state of
        RegistrationScreen _ ->
            "Register new company"

        LoginScreen ->
            "Login"

        _ ->
            "She"


view : Model -> Document Msg
view model =
    { title = titleFromState model.state
    , body =
        [ div ([] ++ Swiper.onSwipeEvents Swiped)
            [ case model.state of
                Loading ->
                    div [] [ text "Loading" ]

                LoginScreen ->
                    LoginScreen.view

                RegistrationScreen data ->
                    Html.map RegistrationMessage <| Registration.view data

                Cards card ->
                    Html.map CardMessage <| CardDisplay.view card

            --let
            --    (state, cmd) = CardDisplay.update card
            --let
            --    displayCard =
            --        Array.get card model.cards
            --in
            --case displayCard of
            --    Nothing ->
            --        div [] [ text "Error" ]
            --
            --    Just c ->
            --        renderCard c
            -- NoCards ->
            --     div [] [ text "No cards available" ]
            ]
        ]
    }


urlForPage : State -> String
urlForPage state =
    case state of
        RegistrationScreen _ ->
            "/register"

        LoginScreen ->
            "/login"

        _ ->
            "/company"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewCards cards ->
            ( { model | state = Cards <| CardDisplay.newCardModel cards }, Cmd.none )

        CardMessage message ->
            case model.state of
                Cards c ->
                    let
                        ( cardState, cardCmd ) =
                            CardDisplay.update message c
                    in
                    ( { model | state = Cards cardState }, cardCmd )

                _ ->
                    ( model, Cmd.none )

        RegistrationMessage message ->
            let
                saveCmd =
                    if message == Save then
                        case model.state of
                            RegistrationScreen data ->
                                [ saveRegistration data ]

                            _ ->
                                []

                    else
                        []

                ( newState, cmd ) =
                    case model.state of
                        RegistrationScreen data ->
                            let
                                ( regstate, refcmd ) =
                                    Registration.update message data
                            in
                            ( RegistrationScreen regstate, Cmd.map RegistrationMessage refcmd )

                        _ ->
                            ( model.state, Cmd.none )
            in
            ( { model | state = newState }, Cmd.batch <| cmd :: saveCmd )

        CardSaved result ->
            --let
            --    _ =
            --        Debug.log "Saved" <| Debug.toString result
            --in
            ( model, Nav.load "/" )

        ChangeUrl url ->
            let
                ( newState, cmd ) =
                    stateFromUrl url.path
            in
            ( { model | state = newState }, cmd )

        ClickLink urlRequest ->
            case urlRequest of
                Internal url ->
                    let
                        ( newState, cmd ) =
                            stateFromUrl url.path
                    in
                    ( model, Cmd.batch [ cmd, Nav.pushUrl model.key <| urlForPage newState ] )

                External url ->
                    ( model, Nav.load url )

        -- SwitchToPage state ->
        --     let
        --         newModel =
        --             { model | state = state }
        --         cmd =
        --             if state == Loading then
        --                 getCards ()
        --             else
        --                 Cmd.none
        --         cmdList =
        --             [ cmd, Nav.pushUrl model.key <| urlForPage state ]
        --     in
        --     ( newModel, Cmd.batch cmdList )
        Swiped evt ->
            case model.state of
                Cards cards ->
                    let
                        ( _, left ) =
                            Swiper.hasSwipedLeft evt model.swipingState

                        ( swipingState, right ) =
                            Swiper.hasSwipedRight evt model.swipingState

                        ( newmodel, _ ) =
                            if left then
                                CardDisplay.update PreviousCard cards

                            else if right then
                                CardDisplay.update NextCard cards

                            else
                                ( cards, Cmd.none )

                        newState =
                            Cards newmodel
                    in
                    ( { model | state = newState, swipingState = swipingState }, Cmd.none )

                _ ->
                    ( model, Cmd.none )


saveRegistration : Registration.RegistrationData -> Cmd msg
saveRegistration data =
    saveCard data.card


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ cardsReceiver NewCards
        , cardSaved CardSaved
        ]


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickLink
        , onUrlChange = ChangeUrl
        }
