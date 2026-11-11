# Walkthrough: Quote to Stop Injection

## The plan
Theo's script is correct for friendly input. Your job is to make it correct for
*any* input by controlling what the shell does after it expands `$customer`.

## What the shell does with an unquoted variable
Expansion happens in a fixed order. After the variable's text is inserted, the
shell performs **word splitting** (on spaces, tabs, newlines) and then
**pathname expansion** (`*`, `?`, `[..]`). Neither step knows the text came from a
user. So:

- `Gull & Anchor Pub` becomes four words, and `cp` receives four arguments.
- `*` becomes the list of existing tickets, and `cp` is asked to overwrite them.
- `x; touch pwned` is split into words but is *not* run: the `;` arrives as a
  plain word. The damage in that case is a wrongly named file, and in other
  scripts (`eval`, `bash -c`, `ssh host "...$name"`) a real command. Quoting is
  the habit that closes the whole family.

## Steps
1. Build the path once, quoted: `target="tickets/$customer.txt"`. Assignments
   never split, but the later uses would.
2. Copy with `cp fixtures/ticket-template.txt "$target"`.
3. Print with `printf 'filed: %s\n' "$target"`, so a name such as `-n` is not
   read as an option for `echo`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh CUSTOMER" >&2
  exit 2
fi
customer=$1
target="tickets/$customer.txt"
cp fixtures/ticket-template.txt "$target"
printf 'filed: %s\n' "$target"
```

## Try it
```
mkdir -p tickets
./solution.sh "Harbour Bakery"
./solution.sh '*'
ls tickets
```

## Alternative
You could use `set -f` to disable globbing and still leave `$customer` unquoted,
but that fixes only half of the problem (splitting remains). Quoting each use is
the single rule that covers both, which is why reviewers ask for it.
