module Util exposing (..)


prependMaybe : Maybe a -> List a -> List a
prependMaybe maybe list =
    case maybe of
        Just value ->
            value :: list

        Nothing ->
            list
