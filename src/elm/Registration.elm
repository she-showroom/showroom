module Registration exposing (..)

import Countries
import Html exposing (Html, button, div, img, input, label, text)
import Html.Attributes as Attributes exposing (class, href, src, value)
import Html.Events exposing (onClick, onInput)
import Model exposing (Card, defaultCard)
import Selectize exposing (Entry)


type FundedState
    = Yes
    | No
    | InProgress


newRegistration : RegistrationData
newRegistration =
    { card = defaultCard
    , countryMenu = Selectize.closed "" identity countryOptions
    , goalsMenu = Selectize.closed "" identity goalsOptions
    , stageMenu = Selectize.closed "" identity stageOptions
    , industryMenu = Selectize.closed "" identity industryOptions
    , fundedMenu = Selectize.closed "" identity vcfundedOptions
    }


type alias RegistrationData =
    { card : Card
    , countryMenu : Selectize.State String
    , goalsMenu : Selectize.State String
    , stageMenu : Selectize.State String
    , industryMenu : Selectize.State String
    , fundedMenu : Selectize.State String
    }


type Msg
    = Save
    | UploadLogo
    | CountryMenuMsg (Selectize.Msg String)
    | SustainableMenuMsg (Selectize.Msg String)
    | StageMenuMsg (Selectize.Msg String)
    | IndustryMenuMsg (Selectize.Msg String)
    | VCFundedMenuMsg (Selectize.Msg String)
    | SelectCountry (Maybe String)
    | SelectGoal (Maybe String)
    | SelectStage (Maybe String)
    | SelectIndustry (Maybe String)
    | SelectFunded (Maybe String)
    | ChangeName String
    | ChangeOpenness String
    | ChangeDescription String
    | ChangeInvestor String
    | ChangeFunding String
    | ChangeDate String
    | ChangeAward1 String
    | ChangeAward2 String
    | ChangeAward3 String


updateName card value =
    { card | name = Just value }


updateCountry card value =
    { card | country = value }


updateGoal card value =
    { card | goal = value }


updateStage card value =
    { card | stage = value }


updateFunded card value =
    { card | funded = value }


udpateIndustry card value =
    { card | industry = value }


updateOpenness card value =
    let
        number =
            String.toInt value
    in
    { card | openness = number }


updateFunding card value =
    { card | funding = Just value }


updateDescription card value =
    { card | description = Just value }


updateInvestor card value =
    { card | investor = Just value }


updateDate card value =
    { card | fundingDate = Just value }


updateAward1 card value =
    { card | award1 = Just value }


updateAward2 card value =
    { card | award2 = Just value }


updateAward3 card value =
    { card | award3 = Just value }


update : Msg -> RegistrationData -> ( RegistrationData, Cmd Msg )
update msg model =
    case msg of
        Save ->
            ( model, Cmd.none )

        UploadLogo ->
            ( model, Cmd.none )

        SelectCountry country ->
            ( { model | card = updateCountry model.card country }, Cmd.none )

        SelectGoal goal ->
            ( { model | card = updateGoal model.card goal }, Cmd.none )

        SelectStage stage ->
            ( { model | card = updateStage model.card stage }, Cmd.none )

        SelectIndustry industry ->
            ( { model | card = udpateIndustry model.card industry }, Cmd.none )

        SelectFunded funded ->
            ( { model | card = updateFunded model.card funded }, Cmd.none )

        CountryMenuMsg sMsg ->
            dropdownUpdate model model.card.country model.countryMenu sMsg SelectCountry

        SustainableMenuMsg sMsg ->
            dropdownUpdate model model.card.goal model.goalsMenu sMsg SelectGoal

        StageMenuMsg sMsg ->
            dropdownUpdate model model.card.stage model.stageMenu sMsg SelectStage

        IndustryMenuMsg sMsg ->
            dropdownUpdate model model.card.industry model.industryMenu sMsg SelectIndustry

        VCFundedMenuMsg sMsg ->
            dropdownUpdate model model.card.funded model.fundedMenu sMsg SelectFunded

        ChangeName val ->
            ( { model | card = updateName model.card val }, Cmd.none )

        ChangeOpenness val ->
            ( { model | card = updateOpenness model.card val }, Cmd.none )

        ChangeDescription val ->
            ( { model | card = updateDescription model.card val }, Cmd.none )

        ChangeInvestor val ->
            ( { model | card = updateInvestor model.card val }, Cmd.none )

        ChangeFunding val ->
            ( { model | card = updateFunding model.card val }, Cmd.none )

        ChangeDate val ->
            ( { model | card = updateDate model.card val }, Cmd.none )

        ChangeAward1 val ->
            ( { model | card = updateAward1 model.card val }, Cmd.none )

        ChangeAward2 val ->
            ( { model | card = updateAward2 model.card val }, Cmd.none )

        ChangeAward3 val ->
            ( { model | card = updateAward3 model.card val }, Cmd.none )


dropdownUpdate : RegistrationData -> Maybe String -> Selectize.State String -> Selectize.Msg String -> (Maybe String -> Msg) -> ( RegistrationData, Cmd Msg )
dropdownUpdate model value list msg modelCmd =
    let
        card =
            model.card

        ( newMenu, menuCmd, maybeMsg ) =
            Selectize.update modelCmd value list msg

        --_ =
        --    Debug.log "Menu" <| Debug.toString newMenu
        --newCard = m
        --
        --newCard =
        --    cardUpdate card newMenu
        --
        --cmdMapped =
        --    menuCmd |> Cmd.map dropDownCmd
    in
    ( model, Cmd.none )



--case maybeMsg of
--    Just nextMsg ->
--        update nextMsg newModel
--            |> andDo cmdMapped
--
--    Nothing ->
--        ( newModel, cmdMapped )


andDo : Cmd msg -> ( model, Cmd msg ) -> ( model, Cmd msg )
andDo cmd ( model, cmds ) =
    ( model
    , Cmd.batch [ cmd, cmds ]
    )


countryOptions : List (Entry String)
countryOptions =
    Countries.all
        |> List.map .name
        |> List.map Selectize.entry


goalsOptions : List (Entry String)
goalsOptions =
    [ "SDG 13", "SDG 14", "SDG 07" ]
        |> List.map Selectize.entry


stageOptions : List (Entry String)
stageOptions =
    [ "Project", "Early startup", "Series A" ]
        |> List.map Selectize.entry


industryOptions : List (Entry String)
industryOptions =
    [ "Fintech", "Enterprise Software", "Energy" ]
        |> List.map Selectize.entry


vcfundedOptions : List (Entry String)
vcfundedOptions =
    [ "Yes", "No", "In progress" ]
        |> List.map Selectize.entry


view : RegistrationData -> Html Msg
view data =
    div [ class "registration-container" ]
        [ img [ class "reg-image", src "img/rocket.png" ] []
        , div [ class "reg-title" ] [ text "Registration" ]
        , div [ class "form" ]
            [ labeledBox "Company Name" <| input [ onInput ChangeName ] [ text "Hallo" ]
            , labeledBox "Country" <|
                Html.map CountryMenuMsg <|
                    Selectize.view (viewConfig "Country") data.card.country data.countryMenu
            , labeledBox "Sustainable Development Goals" <|
                Html.map SustainableMenuMsg <|
                    Selectize.view (viewConfig "Goals") data.card.goal data.goalsMenu
            , labeledBox "Stage" <|
                Html.map StageMenuMsg <|
                    Selectize.view (viewConfig "Stage") data.card.stage data.stageMenu
            , labeledBox "Openness %" <|
                input [ onInput ChangeOpenness ] [ text "Openness" ]
            , labeledBox "Company Description" <|
                input [ onInput ChangeDescription ] [ text "Company Description" ]
            , labeledBox "Industry Category" <|
                Html.map IndustryMenuMsg <|
                    Selectize.view (viewConfig "Industry") data.card.industry data.industryMenu
            , labeledBox "VC funded" <|
                Html.map VCFundedMenuMsg <|
                    Selectize.view (viewConfig "VC Funded") data.card.funded data.fundedMenu
            , labeledBox "Lead investor name (if any)" <|
                input [ onInput ChangeInvestor ] [ text "Lead Investor" ]
            , labeledBox "Last funding amount" <|
                input [ onInput ChangeFunding ] [ text "Last funding amount" ]
            , labeledBox "Last funding closed date" <|
                input [ onInput ChangeDate ] [ text "Last fuding date" ]
            , labeledBox "Company Name" <| input [ onInput ChangeAward1 ] [ text "Award 1" ]
            , labeledBox "Company Name" <| input [ onInput ChangeAward2 ] [ text "Award 2" ]
            , labeledBox "Company Name" <| input [ onInput ChangeAward3 ] [ text "Award 3" ]
            , button [ class "upload-button", onClick UploadLogo ] [ text "Upload Logo" ] -- { onPress = Just UploadLogo, label = "Upload Logo" }
            , button [ class "register-button", onClick Save ] [ text "Register" ] -- { onPress = Just Save, label = "Register" }
            ]
        ]


labeledBox title control =
    div [] [ label [] [ text title ], control ]


viewConfig : String -> Selectize.ViewConfig String
viewConfig placeholder =
    Selectize.viewConfig
        { container = []
        , menu =
            [ Attributes.class "selectize__menu" ]
        , ul =
            [ Attributes.class "selectize__list" ]
        , entry =
            \tree mouseFocused keyboardFocused ->
                { attributes =
                    [ Attributes.class "selectize__item"
                    , Attributes.classList
                        [ ( "selectize__item--mouse-selected"
                          , mouseFocused
                          )
                        , ( "selectize__item--key-selected"
                          , keyboardFocused
                          )
                        ]
                    ]
                , children =
                    [ Html.text tree ]
                }
        , divider =
            \title ->
                { attributes =
                    [ Attributes.class "selectize__divider" ]
                , children =
                    [ Html.text title ]
                }
        , input = textfieldSelector placeholder
        }


textfieldSelector : String -> Selectize.Input String
textfieldSelector placeholder =
    Selectize.autocomplete <|
        { attrs =
            \sthSelected open ->
                [ Attributes.class "selectize__textfield"
                , Attributes.classList
                    [ ( "selectize__textfield--selection", sthSelected )
                    , ( "selectize__textfield--no-selection", not sthSelected )
                    , ( "selectize__textfield--menu-open", open )
                    ]
                ]
        , toggleButton = toggleButton
        , clearButton = clearButton
        , placeholder = "Select a License"
        }


toggleButton : Maybe (Bool -> Html Never)
toggleButton =
    Just <|
        \open ->
            Html.div
                [ Attributes.class "selectize__menu-toggle"
                , Attributes.classList
                    [ ( "selectize__menu-toggle--menu-open", open ) ]
                ]
                [ Html.i
                    [ Attributes.class "material-icons"
                    , Attributes.class "selectize__icon"
                    ]
                    [ if open then
                        Html.text "arrow_drop_up"

                      else
                        Html.text "arrow_drop_down"
                    ]
                ]


clearButton : Maybe (Html Never)
clearButton =
    Just <|
        Html.div
            [ Attributes.class "selectize__menu-toggle" ]
            [ Html.i
                [ Attributes.class "material-icons"
                , Attributes.class "selectize__icon"
                ]
                [ Html.text "clear" ]
            ]
