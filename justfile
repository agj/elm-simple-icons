[private]
@default:
    just --list --unsorted

# Build the Elm code from the source SVG data.
build: install
    nu ./scripts/build.nu

# Preview the documentation.
docs:
    elm-doc-preview --port 8001 --no-browser

# Give standard format to files.
format:
    prettier --write *.md
    elm-format src/** --yes

[private]
install:
    pnpm install
