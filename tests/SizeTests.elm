module SizeTests exposing (..)

import SimpleIcons exposing (toHtml, withSize)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


defaultTests : Test
defaultTests =
    test "Icon SVG has its default size set" <|
        \_ ->
            SimpleIcons.elm
                |> toHtml []
                |> Query.fromHtml
                |> Query.has
                    [ Selector.style "width" "1em"
                    , Selector.style "height" "1em"
                    ]


withSizeTests : Test
withSizeTests =
    describe "withSize"
        [ test "Sets the `width` and `height` style values" <|
            \_ ->
                SimpleIcons.elm
                    |> withSize "123px"
                    |> toHtml []
                    |> Query.fromHtml
                    |> Query.has
                        [ Selector.style "width" "123px"
                        , Selector.style "height" "123px"
                        ]
        ]
