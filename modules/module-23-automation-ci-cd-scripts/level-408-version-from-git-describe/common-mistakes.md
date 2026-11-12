# Common Mistakes

- **Splitting on hyphens.** Wrong: `IFS=- read -r tag n hash <<< "$out"` turns `v1.5.0-rc1-3-gabc` into `tag=v1.5.0`, `n=rc1`. Right: an end-anchored regex, `^v(.+)-([0-9]+)-g([0-9a-f]+)$`.
- **Leaving out `--long`.** Wrong: describe prints only `v1.4.0` on a tagged commit, so your regex fails exactly on release builds. Right: always pass `--long`, then test the distance for 0.
- **Forgetting `--tags`.** Wrong: plain `git describe` only sees annotated tags and may report "No names found". Right: `--tags` (and a `--match` pattern to ignore non-release tags).
- **Crashing on a fresh clone.** Wrong: `ver=$(git describe ...)` under `set -e` aborts when no tag exists. Right: `if ver=$(...); then ... else fallback; fi`.
- **Calling a dirty build clean.** Wrong: dropping the `-dirty` suffix, so a build with local edits looks like the release. Right: keep a visible marker in the version.
