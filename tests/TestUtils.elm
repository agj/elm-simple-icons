module TestUtils exposing (forEachIcon, selectorNoClass)

import Dict
import SimpleIcons exposing (Icon)
import Test.Html.Selector as Selector


{-| Maps a function over a list of all icons, with their slugs.
-}
forEachIcon : (String -> Icon -> a) -> List a
forEachIcon testFn =
    SimpleIcons.allIcons
        |> Dict.toList
        |> List.map (\( slug, icon ) -> testFn slug icon)


{-| Selects an element without any class set.
-}
selectorNoClass : Selector.Selector
selectorNoClass =
    Selector.class ""
