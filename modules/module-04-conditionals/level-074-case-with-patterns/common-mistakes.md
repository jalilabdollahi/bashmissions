# Common Mistakes

- **Putting the general pattern before the specific one.** Everything is claimed by the first branch that fits.
  - Wrong: `*.gz) ... ;; *.tar.gz) ... ;;` (the tar branch is never reached)
  - Right: `*.tar.gz) ... ;; *.gz) ... ;;`
- **Using `||` between patterns.** Alternatives in a case branch are separated by a single `|`.
  - Wrong: `*.tar.gz || *.tgz)`
  - Right: `*.tar.gz | *.tgz)`
- **Quoting the wildcard.** A quoted pattern is literal.
  - Wrong: `"*.zip")` (matches only a file literally named `*.zip`)
  - Right: `*.zip)`
- **Forgetting the default branch.** A name nobody planned for silently falls through with no message and exit status 0.
  - Wrong: no `*)` branch
  - Right: `*) echo "unknown archive type: $file" >&2; exit 1 ;;`
- **Expecting a partial match.** The pattern covers the whole word, so trailing text breaks it.
  - Wrong: expecting `backup.tar.gz.bak` to match `*.tar.gz`
  - Right: add `*.tar.gz*` only if you really want "contains"
