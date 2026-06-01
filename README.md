# elm-simple-icons

Over 3000 project and brand logos as flat SVG icons, from the [Simple
Icons][simple-icons] project, packaged for easy use within Elm.

This package version matches Simple Icons **v16.22.0**.

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
SimpleIcons.wikimediacommons
    |> SimpleIcons.withColor "#FF00FF"
    |> SimpleIcons.withSize "50px"
    |> SimpleIcons.toHtml []
    --: Html msg
```

See a small [example project][example] in the repository, or see the live
[Ellie][ellie].

[example]: https://github.com/agj/elm-simple-icons/tree/1.7.0/examples/icons-list
[ellie]: https://ellie-app.com/yt2yPXwMWFca1

## Installation

```sh
elm install agj/elm-simple-icons
```

Make sure to read the [**package documentation**][package]!

[package]: https://package.elm-lang.org/packages/agj/elm-simple-icons/1.7.0

## Changes

See [`CHANGELOG.md`][changelog] for all changes in each version released.

[changelog]: https://github.com/agj/elm-simple-icons/blob/main/CHANGELOG.md

## Disclaimer

This package only redistributes the content of the Simple Icons project in
a format practical for Elm projects. The same [legal disclaimer][disclaimer]
applies to this content, so please read it before you use the provided icons.

[disclaimer]: https://github.com/simple-icons/simple-icons/blob/develop/DISCLAIMER.md

## No AI slop policy

This project does not use LLMs or any form of generative AI, be it in whole or
in part, for the authoring of its code or any of its related content, and will
not accept such contributions. This policy does not necessarily reflect on the
dependencies and tools used herein.

Please read the [Open Slopware “Why not LLMs?”][why-not-llms] rationale to
learn about the multitude of externalities that plague the use and development
of LLMs.

[why-not-llms]: https://codeberg.org/small-hack/open-slopware/src/commit/69475267031ccf609517dfa254f1916cb435e424/README.md#why-not-llms
