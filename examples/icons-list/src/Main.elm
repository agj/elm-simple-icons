module Main exposing (main)

import Browser
import Dict
import Html exposing (Html)
import Html.Attributes exposing (style)
import SimpleIcons


main : Program () () ()
main =
    Browser.sandbox
        { init = ()
        , update = \() () -> ()
        , view = view
        }


view : () -> Html msg
view () =
    let
        cells =
            SimpleIcons.allIcons
                |> Dict.toList
                |> List.map
                    (\( slug, icon ) ->
                        Html.div [ style "text-align" "center" ]
                            [ icon
                                |> SimpleIcons.withSize "50px"
                                |> SimpleIcons.toHtml []
                            , Html.div [] [ Html.text slug ]
                            ]
                    )
    in
    Html.div
        [ style "display" "grid"
        , style "grid-template-columns" "repeat(10, 80px)"
        , style "gap" "20px"
        , style "margin" "20px"
        , style "font-size" "10px"
        , style "line-height" "1.5em"
        , style "color" "#aac"
        , style "word-break" "break-word"
        ]
        cells
