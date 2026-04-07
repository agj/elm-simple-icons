module TitleTests exposing (..)

import Expect
import SimpleIcons exposing (toHtml, withNoTitle, withTitle)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


defaultTests : Test
defaultTests =
    test "Icon SVG has default <title> element" <|
        \_ ->
            SimpleIcons.elm
                |> toHtml []
                |> Query.fromHtml
                |> Query.find [ Selector.tag "title" ]
                |> Query.has [ Selector.exactText "Elm" ]


withTitleTests : Test
withTitleTests =
    describe "withTitle"
        [ test "Sets the <title> element content" <|
            \_ ->
                SimpleIcons.elm
                    |> withTitle "Some title"
                    |> toHtml []
                    |> Query.fromHtml
                    |> Query.find [ Selector.tag "title" ]
                    |> Query.has [ Selector.exactText "Some title" ]
        , test "Removes the <title> element if set to the empty string" <|
            \_ ->
                SimpleIcons.elm
                    |> withTitle ""
                    |> toHtml []
                    |> Query.fromHtml
                    |> Query.findAll [ Selector.tag "title" ]
                    |> Query.count (Expect.equal 0)
        ]


withNoTitleTests : Test
withNoTitleTests =
    describe "withNoTitle"
        [ test "Removes the <title> element" <|
            \_ ->
                SimpleIcons.elm
                    |> withNoTitle
                    |> toHtml []
                    |> Query.fromHtml
                    |> Query.findAll [ Selector.tag "title" ]
                    |> Query.count (Expect.equal 0)
        ]
