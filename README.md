# elm-simple-icons

Over 3000 project and brand logos as flat SVG icons, from the [Simple
Icons](https://simpleicons.org/) project, packaged for Elm projects.

This package version matches Simple Icons **v16.15.0**.

## Example use

```elm
import SimpleIcons
import Html exposing (Html)

-- Icon with default color and size.
SimpleIcons.elm
    |> SimpleIcons.toHtml []
--: Html msg

-- Icon with custom color and size.
SimpleIcons.svg
    |> SimpleIcons.withColor "#FF00FF"
    |> SimpleIcons.withSize "50px"
    |> SimpleIcons.toHtml []
--: Html msg
```

## Installation

```sh
elm install agj/elm-simple-icons
```

Make sure to read the
[**package documentation**](https://package.elm-lang.org/packages/agj/elm-simple-icons/1.0.0)!

## Disclaimer

This package only redistributes the content of the Simple Icons
project in a format practical for Elm projects. The same [legal
disclaimer](https://github.com/simple-icons/simple-icons/blob/develop/DISCLAIMER.md)
applies to this content, so please read it before you use the provided
icons.
