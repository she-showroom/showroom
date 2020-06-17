module Company.Chat exposing (..)

import Company.Model exposing (Model)
import Company.Util exposing (cardHeader)
import Html exposing (Html, div, img, text)
import Html.Attributes exposing (class, src)
import Model exposing (Card)


renderChat : Card -> Model -> Html msg
renderChat card _ =
    cardHeader (Maybe.withDefault "No Name" card.name) <|
        div [ class "card-sub" ]
            [ div [ class "chat-container" ]
                [ div [ class "chat" ]
                    [ div [ class "title" ] [ text "Founder name" ]
                    , div [ class "timebubble" ] [ text "TUE 14:48 PM" ]
                    , chatrow [ "Great connecting with you." ]
                    , chatrow
                        [ "Could I request for a demo?"
                        , "We are looking to invest in COVID related problem-solving solutions."
                        ]
                    ]
                , div [ class "chat-input" ]
                    [ icon "plus"
                    , icon "camera"
                    , icon "photo"
                    , icon "mic"
                    , div [ class "input" ] [ text "Message" ]
                    ]
                ]
            ]


icon file =
    div [ class "icon" ] [ img [ src ("img/" ++ file ++ ".svg") ] [] ]


chatrow content =
    div [ class "chatrow" ]
        [ img [ src "img/checker.png" ] []
        , div [ class "bubble" ]
            (List.map (\t -> div [] [ text t ]) content)
        ]
