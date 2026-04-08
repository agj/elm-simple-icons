module ToHtmlTests exposing (..)

import Html.Attributes
import Html.Events
import SimpleIcons exposing (toHtml)
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector as Selector
import TestUtils exposing (selectorNoClass)


defaultTests : Test
defaultTests =
    test "Icon SVG has no classes set" <|
        \_ ->
            SimpleIcons.elm
                |> toHtml []
                |> Query.fromHtml
                |> Query.has [ selectorNoClass ]


toHtmlTests : Test
toHtmlTests =
    describe "toHtml"
        [ test "Can set a class" <|
            \_ ->
                SimpleIcons.elm
                    |> toHtml [ Html.Attributes.class "MY-CLASS" ]
                    |> Query.fromHtml
                    |> Query.has [ Selector.class "MY-CLASS" ]
        , test "Can set a click event" <|
            \_ ->
                SimpleIcons.elm
                    |> toHtml [ Html.Events.onClick "CLICKED" ]
                    |> Query.fromHtml
                    |> Event.simulate Event.click
                    |> Event.expect "CLICKED"
        , test "Can set a style" <|
            \_ ->
                SimpleIcons.elm
                    |> toHtml [ Html.Attributes.style "margin" "5rem" ]
                    |> Query.fromHtml
                    |> Query.has [ Selector.style "margin" "5rem" ]
        ]
