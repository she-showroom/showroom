module Model exposing (..)


type alias Card =
    { goal : Maybe String
    , country : Maybe String
    , name : Maybe String
    , icon : Maybe String
    , stage : Maybe String
    , relevancy : Maybe Int
    , openness : Maybe Int
    , funded : Maybe String
    , funding : Maybe String
    , fundingDate : Maybe String
    , investor : Maybe String
    , award1 : Maybe String
    , award2 : Maybe String
    , award3 : Maybe String
    , industry : Maybe String
    , description : Maybe String
    , id : Maybe String
    }


defaultCard : Card
defaultCard =
    { goal = Nothing
    , country = Just "DE"
    , name = Nothing
    , icon = Nothing
    , stage = Nothing
    , relevancy = Just 2
    , openness = Just 20
    , funded = Nothing
    , funding = Nothing
    , fundingDate = Nothing
    , investor = Nothing
    , award1 = Nothing
    , award2 = Nothing
    , award3 = Nothing
    , industry = Nothing
    , description = Nothing
    , id = Nothing
    }


type alias Financial =
    { icon : String
    , title : List String
    }


type alias Achievement =
    { icon : String
    , title : List String
    }
