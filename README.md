# elm-simple-icons

Over 3000 project and brand logos as flat SVG icons, from the [Simple
Icons][simple-icons] project, packaged for easy use within Elm.

This package version matches Simple Icons **v16.15.0**.

[simple-icons]: https://simpleicons.org/

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

See a small [example project][example] in the repository.

[example]: https://github.com/agj/elm-simple-icons/tree/1.0.0/examples/icons-list

## Installation

```sh
elm install agj/elm-simple-icons
```

Make sure to read the [**package documentation**][package]!

[package]: https://package.elm-lang.org/packages/agj/elm-simple-icons/1.0.0

## Changes

See [`CHANGELOG.md`][changelog] for all changes in each version released.

[changelog]: https://github.com/agj/elm-simple-icons/blob/main/CHANGELOG.md

## Disclaimer

This package only redistributes the content of the Simple Icons project in
a format practical for Elm projects. The same [legal disclaimer][disclaimer]
applies to this content, so please read it before you use the provided icons.

[disclaimer]: https://github.com/simple-icons/simple-icons/blob/develop/DISCLAIMER.md
