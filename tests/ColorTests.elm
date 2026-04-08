module ColorTests exposing (..)

import SimpleIcons exposing (toHtml, withColor, withInheritedTextColor)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (forEachIcon)


defaultTests : Test
defaultTests =
    describe "default" <|
        ([ ( "elm", SimpleIcons.elm, "#1293D8" )
         , ( "forgejo", SimpleIcons.forgejo, "#FB923C" )
         , ( "gleam", SimpleIcons.gleam, "#FFAFF3" )
         , ( "mastodon", SimpleIcons.mastodon, "#6364FF" )
         , ( "svg", SimpleIcons.svg, "#FFB13B" )
         , ( "wikimediafoundation", SimpleIcons.wikimediafoundation, "#000000" )
         ]
            |> List.map
                (\( slug, icon, color ) ->
                    test ("Icon SVG has its default color set (" ++ slug ++ ")") <|
                        \_ ->
                            icon
                                |> toHtml []
                                |> Query.fromHtml
                                |> Query.has [ Selector.style "fill" color ]
                )
        )


withColorTests : Test
withColorTests =
    describe "withColor" <|
        forEachIcon <|
            \slug icon ->
                test ("Sets the `fill` style value (" ++ slug ++ ")") <|
                    \_ ->
                        icon
                            |> withColor "#aabbcc"
                            |> toHtml []
                            |> Query.fromHtml
                            |> Query.has [ Selector.style "fill" "#aabbcc" ]


withInheritedTextColorTests : Test
withInheritedTextColorTests =
    describe "withInheritedTextColor" <|
        forEachIcon <|
            \slug icon ->
                test ("Sets the `fill` style value to `currentColor` (" ++ slug ++ ")") <|
                    \_ ->
                        icon
                            |> withInheritedTextColor
                            |> toHtml []
                            |> Query.fromHtml
                            |> Query.has [ Selector.style "fill" "currentColor" ]
