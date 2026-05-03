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

# Check compilation and tests.
[group("check")]
check: build
    @echo "ℹ️ Compiling examples…"
    cd ./examples/icons-list/ && elm make Main.elm --output=/dev/null
    @echo "ℹ️ Compiling docs…"
    elm make --docs=deleteme.json && rm deleteme.json
    @echo "ℹ️ Running elm-review…"
    elm-review
    @echo "ℹ️ Running tests…"
    elm-test
    @echo "✅ All okay."

# Run tests in watch mode.
[group("check")]
test-watch:
    elm-test --watch

# Update the Simple Icons source package.
[group("update")]
update:
    nu ./scripts/update-si-package.nu

# Show changes in the generated Elm module versus the latest release.
[group("update")]
diff: build
    git diff --unified=10 'releases:src/SimpleIcons.elm' 'src/SimpleIcons.elm'

# Bump this package version.
[group("update")]
bump:
    nu ./scripts/bump-version.nu

[private]
install:
    pnpm install
