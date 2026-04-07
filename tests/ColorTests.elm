module ColorTests exposing (..)

import SimpleIcons exposing (toHtml, withColor, withInheritedTextColor)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


defaultTests : Test
defaultTests =
    test "Icon SVG has its default color set" <|
        \_ ->
            SimpleIcons.elm
                |> toHtml []
                |> Query.fromHtml
                |> Query.has [ Selector.style "fill" "#1293D8" ]


withColorTests : Test
withColorTests =
    describe "withColor"
        [ test "Sets the `fill` style value" <|
            \_ ->
                SimpleIcons.elm
                    |> withColor "#aabbcc"
                    |> toHtml []
                    |> Query.fromHtml
                    |> Query.has [ Selector.style "fill" "#aabbcc" ]
        ]


withInheritedTextColorTests : Test
withInheritedTextColorTests =
    describe "withInheritedTextColor"
        [ test "Sets the `fill` style value to `currentColor`" <|
            \_ ->
                SimpleIcons.elm
                    |> withInheritedTextColor
                    |> toHtml []
                    |> Query.fromHtml
                    |> Query.has [ Selector.style "fill" "currentColor" ]
        ]
