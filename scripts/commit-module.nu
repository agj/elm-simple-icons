use ./utils/utils.nu [git-branch-is, git-has-changes, get-local-version]

let canProceed = (git-branch-is "releases") and (not (git-has-changes))

if (not $canProceed) {
  print "❌ There are uncommitted changes, or the branch is not `releases`."
  exit 1
}

let version = get-local-version

print "ℹ️ Building…"

just build

print "ℹ️ Committing modified module…"

git add ./src/SimpleIcons.elm --force
git commit -m "Update generated module"

print $"ℹ️ Adding Git tag for current version \(($version))…"

git tag $version

print "✅ Done!"
