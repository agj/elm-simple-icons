[private]
@default:
    just --list --unsorted

# Build the Elm code from the source SVG data.
build: install
    nu ./scripts/build.nu

# Preview the documentation.
docs:
    elm-doc-preview --port 8001 --no-browser

# Attempts to update the Simple Icons source package.
update:
    nu ./scripts/update-si-package.nu

# Give standard format to files.
format:
    prettier --write *.md
    elm-format ./src/** --yes

# Checks compilation and tests.
check: build
    @echo "ℹ️ Compiling examples…"
    cd ./examples/icons-list/ && elm make Main.elm --output=/dev/null
    @echo "ℹ️ Running tests…"
    elm-test
    @echo "ℹ️ Compiling docs…"
    elm make --docs=deleteme.json && rm deleteme.json
    @echo "ℹ️ Running elm-review…"
    elm-review
    @echo "✅ All okay."

# Runs tests in watch mode.
test-watch:
    elm-test --watch

[private]
install:
    pnpm install
