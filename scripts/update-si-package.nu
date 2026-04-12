# Constants.

let siPackageName = "simple-icons"
let docVersionRegex = 'Simple Icons [*][*]v(\d+[.]\d+[.]\d+)[*][*]'
def doc-version-replace [version] { $"Simple Icons **v($version)**" }

# Functions.

def get-current-si-version [] {
  open "package.json" | get devDependencies | get $siPackageName
}

def update-file [filename, version] {
  let content = open $filename
  let newContent = $content | str replace --regex $docVersionRegex (doc-version-replace $version)

  if ($content == $newContent) {
    print $"❌ Could not replace the version in the file `($filename)`."
    exit 1
  }

  $newContent | save --force $filename
}

def changelog-has-unreleased [] {
  let content = open "CHANGELOG.md"
  (($content | lines | where $in =~ '^## Unreleased' | is-not-empty))
}

def git-has-changes [] {
  git diff HEAD | is-not-empty
}

def git-branch-is [branchName] {
  git branch --show-current | $in == $branchName
}

# Finds changes using `elm diff` and returns a list of changed icons with the
# type of change.
# 
# This is an example of an “added” icon: `{ slug: 'anicon', change: 'Added' }`
def get-changed-icons [] {
  let groupRegex = '^    (\w+):$'
  let iconRegex = '^        (\w+) :.*$'

  let icons = elm diff | lines | reduce --fold { group: null, icons: [] } {|line, acc|
    if ($line =~ $groupRegex) {
      let group = $line | str replace --regex $groupRegex '$1'
      { group: $group, icons: $acc.icons }
    } else if ($acc.group != null) and ($line =~ $iconRegex) {
      let icon = $line | str replace --regex $iconRegex '$1'
      { group: $acc.group, icons: [...$acc.icons, { slug: $icon, change: $acc.group }] }
    } else {
      $acc
    }
  }

  $icons.icons
}

def changed-icons-to-markdown [change] {
  where change == $change | get slug | each { $"`($in)`" } | str join ", "
}

# Update package version.

print "ℹ️ Attempting to update simple-icons npm package version…"

let versionBefore = get-current-si-version
let canCommit = (git-branch-is "dev") and (not (git-has-changes))

if (not $canCommit) {
  print "ℹ️ Won't automatically commit, as there are unsaved changes, or the branch is not `dev`."
}

ncu $siPackageName -u

let versionAfter = get-current-si-version

if ($versionAfter == $versionBefore) {
  print $"✅ No changes made! Already up-to-date \(v($versionBefore))."
  exit
}

print "ℹ️ Updating lockfile…"
pnpm install

print $"ℹ️ Updating from v($versionBefore) to v($versionAfter)…"

print "ℹ️ Updating readme…"
update-file "README.md" $versionAfter

if (changelog-has-unreleased) {
  print "ℹ️ Updating changelog's “Unreleased” block…"
  update-file "CHANGELOG.md" $versionAfter
} else {
  print "ℹ️ Changelog has no “Unreleased” block. Skipped."
}

if ($canCommit) {
  print "ℹ️ Committing…"

  git add .
  git commit -m $"Update source simple-icons to v($versionAfter)"
}

print "✅ Updated! Remember to run `just build`."
