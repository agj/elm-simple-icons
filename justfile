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
    elm-format ./src/** --yes

# Check that everything compiles.
check:
    @echo "ℹ️ Compiling examples…"
    cd ./examples/icons-list/ && elm make Main.elm --output=/dev/null
    @echo "✅ All okay."

[private]
install:
    pnpm install
