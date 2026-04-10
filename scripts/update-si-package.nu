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

# Update package version.

let versionBefore = get-current-si-version

print "ℹ️ Attempting to update simple-icons npm package version…"

ncu $siPackageName -u

let versionAfter = get-current-si-version

if ($versionAfter == $versionBefore) {
  print $"✅ We're currently at the latest version ($versionBefore)!"
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

print "✅ Updated! Remember to run `just build`."
