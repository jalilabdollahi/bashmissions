# Common Mistakes

- **Trusting the text of the path.** `..` and symlinks defeat string checks.
  - Wrong: `[[ $dir == shared/* ]]` accepts `shared/../secret`
  - Right: `resolved=$(cd "$dir" && pwd -P)` and compare that
- **A wildcard after a variable.** With the variable empty it becomes `/*`.
  - Wrong: `rm -rf "$dir"/*`
  - Right: check `$dir` first, then `rm -rf -- "$resolved"`
- **Prefix matching without the slash.** `shared-old` starts with `shared`.
  - Wrong: `[[ $resolved == "$base"* ]]`
  - Right: `case "$resolved/" in "$base"/*)`
- **Forgetting to refuse the base itself.** "Anything under shared" should not include `shared`.
  - Wrong: only testing "starts with base"
  - Right: `[[ $resolved == "$base" ]]` is a refusal of its own
- **Deleting by the unresolved name after checking the resolved one.** The two can differ.
  - Wrong: `rm -rf "$dir"` after checking `$resolved`
  - Right: `rm -rf -- "$resolved"`
