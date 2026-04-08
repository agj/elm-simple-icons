module TitleTests exposing (..)

import Expect
import SimpleIcons exposing (toHtml, withNoTitle, withTitle)
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (forEachIcon)


defaultTests : Test
defaultTests =
    describe "default" <|
        ([ ( "elm", SimpleIcons.elm, "Elm" )
         , ( "forgejo", SimpleIcons.forgejo, "Forgejo" )
         , ( "gleam", SimpleIcons.gleam, "Gleam" )
         , ( "mastodon", SimpleIcons.mastodon, "Mastodon" )
         , ( "svg", SimpleIcons.svg, "SVG" )
         , ( "wikimediafoundation", SimpleIcons.wikimediafoundation, "Wikimedia Foundation" )
         ]
            |> List.map
                (\( slug, icon, title ) ->
                    test ("Icon SVG has default `<title>` element (" ++ slug ++ ")") <|
                        \_ ->
                            icon
                                |> toHtml []
                                |> Query.fromHtml
                                |> Query.find [ Selector.tag "title" ]
                                |> Query.has [ Selector.exactText title ]
                )
        )


withTitleTests : Test
withTitleTests =
    describe "withTitle" <|
        forEachIcon <|
            \slug icon ->
                describe slug
                    [ test "Sets the `<title>` element content" <|
                        \_ ->
                            icon
                                |> withTitle "SOME TITLE"
                                |> toHtml []
                                |> Query.fromHtml
                                |> Query.find [ Selector.tag "title" ]
                                |> Query.has [ Selector.exactText "SOME TITLE" ]
                    , test "Removes the `<title>` element if set to the empty string" <|
                        \_ ->
                            icon
                                |> withTitle ""
                                |> toHtml []
                                |> Query.fromHtml
                                |> Query.findAll [ Selector.tag "title" ]
                                |> Query.count (Expect.equal 0)
                    ]


withNoTitleTests : Test
withNoTitleTests =
    describe "withNoTitle" <|
        forEachIcon <|
            \slug icon ->
                test ("Removes the `<title>` element (" ++ slug ++ ")") <|
                    \_ ->
                        icon
                            |> withNoTitle
                            |> toHtml []
                            |> Query.fromHtml
                            |> Query.findAll [ Selector.tag "title" ]
                            |> Query.count (Expect.equal 0)
