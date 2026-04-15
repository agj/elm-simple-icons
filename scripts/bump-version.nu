# CONSTANTS

let stringVersionReplacements: list<closure> = [
  {|v| $"elm-simple-icons/tree/($v)" }
  {|v| $"elm-simple-icons/($v)" }
]


# FUNCTIONS

def get-current-version []: nothing -> string {
  open "elm.json" | get version
}

def bump-version []: nothing -> nothing {
  echo 'y' | elm bump
}

def update-versions [versionBefore: string, versionAfter: string]: string -> string {
  let source = $in
  $stringVersionReplacements | reduce --fold $source {|getString, acc|
      $acc | str replace --all (do $getString $versionBefore) (do $getString $versionAfter)
    }
}


# BUMP VERSION

let versionBefore = get-current-version

print "ℹ️ Bumping Elm package version…"
bump-version

let versionAfter = get-current-version

print $"ℹ️ Bumped from v($versionBefore) to v($versionAfter) in `elm.json`."

print "ℹ️ Updating readme…"

open "README.md"
  | update-versions $versionBefore $versionAfter
  | save --force "README.md"

print "ℹ️ Formatting…"
just format
