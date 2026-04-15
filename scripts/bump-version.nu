use ./utils/utils.nu [git-branch-is, git-has-changes]

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

print "ℹ️ Bumping Elm package version…"

let versionBefore = get-current-version
let canCommit = (git-branch-is "dev") and (not (git-has-changes))

if (not $canCommit) {
  print "⚠️ Won't automatically commit, as there are unsaved changes, or the branch is not `dev`."
}

bump-version

let versionAfter = get-current-version

print $"ℹ️ Bumped from v($versionBefore) to v($versionAfter) in `elm.json`."

print "ℹ️ Updating readme…"

open "README.md"
  | update-versions $versionBefore $versionAfter
  | save --force "README.md"

print "ℹ️ Formatting…"
just format

if ($canCommit) {
  print "ℹ️ Committing…"

  git add .
  git commit -m $"Bumped version to v($versionAfter)"
}

print "✅ Bumped successfully!"
