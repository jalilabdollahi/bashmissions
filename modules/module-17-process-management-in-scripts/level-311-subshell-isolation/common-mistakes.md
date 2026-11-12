# Common Mistakes

- **Expecting changes to escape.** A variable set in ( ) is gone afterwards.
  - Wrong: `( result=42 ); echo "$result"` prints an empty line.
  - Right: have the subshell print it and capture with `result=$( ... )`, or do the work outside.
- **Thinking `exit` inside ( ) ends the script.** It ends only the subshell.
  - Right: read `$?` after the `)` and decide yourself whether to exit.
- **Letting a non-zero subshell stop a `set -e` script.**
  - Wrong: `( ...; exit 7 )` followed directly by your report line.
  - Right: `status=0; ( ... ) || status=$?`
- **Forgetting `export`.** A plain variable is not visible to an external program started inside the subshell.
  - Wrong: `( PROBE_LABEL=x; probe )` shows `label=none`.
  - Right: `( export PROBE_LABEL=x; probe )` or `PROBE_LABEL=x probe`.
- **Using `{ }` when you wanted isolation.** Braces run in the *current* shell, so nothing is protected (next-but-one level).
