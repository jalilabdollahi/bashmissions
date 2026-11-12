# Walkthrough: Starts With, Ends With

## The plan
Loop over the names. For each, walk down a chain of tests in the order the rules
are given and set a label from the first test that succeeds.

## Pattern matching with `[[ ]]`
Inside `[[ ... ]]` the `==` operator does not compare plain strings: the right-hand
side is a **glob pattern** (as in the trimming levels). That gives you two checks
for free:

- `[[ $name == .* ]]` : starts with a dot (what follows can be anything)
- `[[ $name == *.pem ]]` : ends with `.pem` (anything can come before)

The pattern must be unquoted for `*` to work as a wildcard. A quoted pattern is
compared character by character.

## Order matters
`backup-server.pem` fits both "ends with .pem" and "starts with backup-". The
spec says quarantine wins, so the `.pem` test must come before the `backup-` test.
`.secret.pem` starts with a dot, which is rule 1, so it is hidden. An `if/elif`
chain stops at the first branch that matches, which gives you exactly that.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
for name in "$@"; do
  if [[ $name == .* ]]; then
    label=hidden
  elif [[ $name == *.pem ]]; then
    label=quarantine
  elif [[ $name == backup-* ]]; then
    label=archive
  else
    label=accept
  fi
  echo "$name: $label"
done
```

## Try it by hand
```bash
./solution.sh .env id_rsa.pem backup-server.pem "Q3 report.pem" menu.pdf
```

## Alternative
A `case` statement with patterns (`.*) ... ;; *.pem) ...`) does the same and is
the more traditional layout for many rules. `[[ ]]` is the better fit when the
conditions mix with other tests, such as `-f` or `-n`.
