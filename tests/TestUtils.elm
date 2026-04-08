module TestUtils exposing (selectorNoClass)

import Test.Html.Selector as Selector


{-| Selects an element without any class set.
-}
selectorNoClass : Selector.Selector
selectorNoClass =
    Selector.class ""
