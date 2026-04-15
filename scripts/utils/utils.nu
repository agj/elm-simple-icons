# Checks whether there are uncommitted Git changes.
export def git-has-changes []: nothing -> bool {
  git diff HEAD | is-not-empty
}

# Checks if the current Git branch matches the specified one.
export def git-branch-is [branchName: string]: nothing -> bool {
  git branch --show-current | $in == $branchName
}
