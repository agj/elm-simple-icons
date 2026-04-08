module ToHtmlTests exposing (..)

import Html.Attributes
import Html.Events
import SimpleIcons exposing (toHtml)
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (forEachIcon, selectorNoClass)


defaultTests : Test
defaultTests =
    describe "default" <|
        ([ ( "elm", SimpleIcons.elm )
         , ( "forgejo", SimpleIcons.forgejo )
         , ( "gleam", SimpleIcons.gleam )
         , ( "mastodon", SimpleIcons.mastodon )
         , ( "svg", SimpleIcons.svg )
         , ( "wikimediafoundation", SimpleIcons.wikimediafoundation )
         ]
            |> List.map
                (\( slug, icon ) ->
                    test ("Icon SVG has no classes set (" ++ slug ++ ")") <|
                        \_ ->
                            icon
                                |> toHtml []
                                |> Query.fromHtml
                                |> Query.has [ selectorNoClass ]
                )
        )


toHtmlTests : Test
toHtmlTests =
    describe "toHtml" <|
        forEachIcon <|
            \slug icon ->
                describe slug
                    [ test "Can set a class" <|
                        \_ ->
                            icon
                                |> toHtml [ Html.Attributes.class "MY-CLASS" ]
                                |> Query.fromHtml
                                |> Query.has [ Selector.class "MY-CLASS" ]
                    , test "Can set a click event" <|
                        \_ ->
                            icon
                                |> toHtml [ Html.Events.onClick "CLICKED" ]
                                |> Query.fromHtml
                                |> Event.simulate Event.click
                                |> Event.expect "CLICKED"
                    , test "Can set a style" <|
                        \_ ->
                            icon
                                |> toHtml [ Html.Attributes.style "margin" "5rem" ]
                                |> Query.fromHtml
                                |> Query.has [ Selector.style "margin" "5rem" ]
                    ]
