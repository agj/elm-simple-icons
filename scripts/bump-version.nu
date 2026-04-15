# FUNCTIONS

def get-current-version []: nothing -> string {
  open "elm.json" | get version
}

def bump-version []: nothing -> nothing {
  echo 'y' | elm bump
}


# BUMP VERSION

let versionBefore = get-current-version

print "ℹ️ Bumping Elm package version…"
bump-version

let versionAfter = get-current-version

print $"ℹ️ Bumped from v($versionBefore) to v($versionAfter) in `elm.json`."

print "ℹ️ Updating readme…"

let updatedReadmeText = open "README.md"
  | str replace --all $"elm-simple-icons/tree/($versionBefore)/" $"elm-simple-icons/tree/($versionAfter)/"
  | str replace --all $"elm-simple-icons/($versionBefore)" $"elm-simple-icons/($versionAfter)"

$updatedReadmeText | save --force "README.md"

print "ℹ️ Formatting…"
just format
