[private]
@default:
    just --list --unsorted

# Build the Elm code from the source SVG data.
build: install
    nu ./scripts/build.nu

# Preview the documentation.
[group("docs")]
docs:
    elm-doc-preview --port 8001 --no-browser

[private]
install:
    pnpm install
