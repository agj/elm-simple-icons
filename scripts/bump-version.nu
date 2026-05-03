use ./utils/utils.nu [git-branch-is, git-has-changes, get-local-version]

# CONSTANTS

# List of functions that take a package version number and return a string to
# search for and replace, to update the version in the documentation.
let stringVersionReplacements: list<closure> = [
  {|v| $"elm-simple-icons/tree/($v)" }
  {|v| $"elm-simple-icons/($v)" }
]


# FUNCTIONS

# Bumps the package version up in `elm.json`.
def bump-version []: nothing -> nothing {
  echo 'y' | elm bump
}

# Replaces all substrings containing the old package version with the new
# version.
def update-versions [versionBefore: string, versionAfter: string]: string -> string {
  let source = $in
  $stringVersionReplacements | reduce --fold $source {|getString, acc|
      $acc | str replace --all (do $getString $versionBefore) (do $getString $versionAfter)
    }
}


# BUMP VERSION

let versionBefore = get-local-version
let canCommit = (git-branch-is "dev") and (not (git-has-changes))

if (not $canCommit) {
  print "⚠️ Won't automatically commit, as there are uncommitted changes, or the branch is not `dev`."
}

print "ℹ️ Building…"
just build

print "ℹ️ Bumping Elm package version…"
bump-version

let versionAfter = get-local-version

print $"ℹ️ Bumped from v($versionBefore) to v($versionAfter) in `elm.json`."

print "ℹ️ Updating readme…"

open "README.md"
  | update-versions $versionBefore $versionAfter
  | save --force "README.md"

print "ℹ️ Updating changelog…"

let changelogLines = open "CHANGELOG.md" | lines
let unreleasedHeader = "## Unreleased"
let changelogUnreleasedHeaderLines = $changelogLines | enumerate | where item == $unreleasedHeader

if (($changelogUnreleasedHeaderLines | length) == 0) {
  print "❌ The changelog does not have an “Unreleased” section."
  exit 1
}

let unreleasedHeaderIndex = $changelogLines | enumerate | where item == $unreleasedHeader | get 0.index
let date = date now | format date "%Y-%m-%d"
let unreleasedHeaderReplacement = $"
## [($versionAfter)] \(($date))

[($versionAfter)]: https://github.com/agj/elm-simple-icons/compare/($versionBefore)..($versionAfter)"

let newChangelogLines = [
    ...($changelogLines | first $unreleasedHeaderIndex),
    $unreleasedHeaderReplacement,
    ...($changelogLines | skip ($unreleasedHeaderIndex + 1)),
  ]

$newChangelogLines | str join "\n" | save --force "CHANGELOG.md"

print "ℹ️ Formatting…"
just format

if ($canCommit) {
  print "ℹ️ Committing…"

  git add .
  git commit -m $"Bumped version to v($versionAfter)"
}

print "✅ Bumped successfully!"
