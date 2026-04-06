[private]
@default:
    just --list --unsorted

# Preview the documentation.
[group("docs")]
docs:
    elm-doc-preview --port 8001 --no-browser

[private]
install:
    pnpm install
