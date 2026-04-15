# Changelog for elm-simple-icons

All notable changes to this project will be documented in this file. The format
is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [1.1.0] (2026-04-12)

[1.1.0]: https://github.com/agj/elm-simple-icons/compare/1.0.0..1.1.0

Updated for Simple Icons **v16.16.0**.

## [1.0.0] (2026-04-08)

[1.0.0]: https://github.com/agj/elm-simple-icons/tree/1.0.0

Matches Simple Icons **v16.15.0**.

### Added

- 3420 icons of type `Icon`, which can be converted to SVG/HTML using `toHtml`.
- The following configuration functions: `withColor`, `withInheritedTextColor`,
  `withSize`, `withTitle`, `withNoTitle`.
- A way to iterate over all icons in the `allIcons` `Dict`.
- The `icons-list` example project.
- Tests for all configuration functions and for `toHtml`.
