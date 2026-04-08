module SizeTests exposing (..)

import Dict
import SimpleIcons exposing (toHtml, withSize)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (forEachIcon)


defaultTests : Test
defaultTests =
    describe "default" <|
        forEachIcon <|
            \slug icon ->
                test ("Icon SVG has its default size set (" ++ slug ++ ")") <|
                    \_ ->
                        icon
                            |> toHtml []
                            |> Query.fromHtml
                            |> Query.has
                                [ Selector.style "width" "1em"
                                , Selector.style "height" "1em"
                                ]


withSizeTests : Test
withSizeTests =
    describe "withSize" <|
        forEachIcon <|
            \slug icon ->
                test ("Sets the `width` and `height` style values (" ++ slug ++ ")") <|
                    \_ ->
                        icon
                            |> withSize "123px"
                            |> toHtml []
                            |> Query.fromHtml
                            |> Query.has
                                [ Selector.style "width" "123px"
                                , Selector.style "height" "123px"
                                ]
