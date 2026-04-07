module Main exposing (main)

import Browser
import Dict
import Html exposing (Html)
import Html.Attributes exposing (style, value)
import Html.Events
import SimpleIcons


main : Program () Model Msg
main =
    Browser.sandbox
        { init = { color = Default }
        , update = update
        , view = view
        }


type alias Model =
    { color : Color }


type Color
    = Default
    | Inherit
    | Blue


type Msg
    = ColorSelected Color


update : Msg -> Model -> Model
update msg model =
    case msg of
        ColorSelected color ->
            { color = color }


view : Model -> Html Msg
view model =
    Html.div
        [ style "display" "flex"
        , style "flex-direction" "column"
        , style "gap" "40px"
        , style "margin" "40px"
        ]
        [ viewColorControls model.color
        , viewIcons model.color
        ]


viewColorControls : Color -> Html Msg
viewColorControls color =
    Html.div []
        [ Html.text "Icon color: "
        , Html.select
            [ value (colorToString color)
            , Html.Events.onInput (\selection -> ColorSelected (stringToColor selection))
            ]
            [ viewColorControlsOption Default
            , viewColorControlsOption Inherit
            , viewColorControlsOption Blue
            ]
        ]


viewColorControlsOption : Color -> Html Msg
viewColorControlsOption color =
    Html.option [ value (colorToString color) ] [ Html.text (colorToString color) ]


viewIcons : Color -> Html Msg
viewIcons color =
    Html.div
        [ style "display" "grid"
        , style "grid-template-columns" "repeat(10, 80px)"
        , style "gap" "20px"
        , style "font-size" "10px"
        , style "line-height" "1.5em"
        , style "color" "#aac"
        , style "text-align" "center"
        , style "word-break" "break-word"
        ]
        (viewIconCells color)


viewIconCells : Color -> List (Html Msg)
viewIconCells color =
    SimpleIcons.allIcons
        |> Dict.toList
        |> List.map
            (\( slug, icon ) ->
                Html.div []
                    [ icon
                        |> SimpleIcons.withSize "50px"
                        |> withColor color
                        |> SimpleIcons.toHtml []
                    , Html.div [] [ Html.text slug ]
                    ]
            )


colorToString : Color -> String
colorToString color =
    case color of
        Default ->
            "default"

        Inherit ->
            "inherit"

        Blue ->
            "blue"


stringToColor : String -> Color
stringToColor selected =
    case selected of
        "inherit" ->
            Inherit

        "blue" ->
            Blue

        _ ->
            Default


withColor : Color -> SimpleIcons.Icon -> SimpleIcons.Icon
withColor color icon =
    case color of
        Default ->
            icon

        Inherit ->
            SimpleIcons.withInheritedTextColor icon

        Blue ->
            SimpleIcons.withColor "#33e" icon
