module Company.Model exposing (..)

import Array exposing (Array)
import Dict exposing (Dict)
import Model exposing (Card)


type State
    = Showroom
    | Financials
    | Saved
    | Chat


type CompanySaveType
    = Reject
    | Save
    | Like


type alias Model =
    { cards : Array Card, activeCard : Int, state : State, save : Dict String CompanySaveType }


type Msg
    = LikeCompany
    | DislikeCompany
    | SaveCompany
    | PreviousCard
    | NextCard
    | SetState State
