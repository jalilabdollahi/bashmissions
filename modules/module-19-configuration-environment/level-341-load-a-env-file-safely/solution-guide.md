# Walkthrough: Load a .env File Safely

## The plan

`source .env` is convenient because Bash does the parsing for you. That is also
the problem: the parser is the full shell language, so a line such as
`X=$(touch pwned)` is a command, not a setting. Our plan is to do the parsing
ourselves, with just enough rules to understand `KEY=VALUE`, and to hand the
result to `export` as plain text.

## Building it

First the guard. An unreadable file is an error with exit status 1:

```bash
file=${1:-}
if [[ ! -r $file || -d $file ]]; then echo "cannot read $file" >&2; exit 1; fi
```

Then the loop. `IFS= read -r` keeps leading blanks and backslashes, and the
`|| [[ -n $line ]]` part saves a last line that has no newline.

Classify each line with a regex. Blank or comment lines match
`^[[:space:]]*(#.*)?$` and are skipped. A setting matches
`^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)[[:space:]]*=(.*)$`. The first group is the
key; the second is everything after the FIRST `=` (the key pattern cannot contain
`=`, so later equals signs stay in the value). Anything else is reported with its
line number.

Clean the value: drop surrounding blanks, then peel one pair of quotes with a
glob test and `${value:1:${#value}-2}`.

Finally `export "$key=$value"`. Because the argument is a string that already
holds the final text, Bash does not look inside it for `$(...)` again.

## Complete solution

See answer.sh: guard, loop, classify, trim, unquote, export, then three
`echo "name=${SITE_NAME:-(unset)}"` lines.

## Trying it by hand

```
printf 'SITE_NAME="Pier Pizza"\nSITE_PORT=$(date)\n' > t.env
./solution.sh t.env
```

The port prints as the literal text `$(date)`.

## Alternative

You could loop with `IFS== read -r key value`. It is shorter, but it cannot tell
a comment from a key, it does not validate names, and it trims nothing. For a
quick script on a trusted file it works; for customer-edited files, the regex is
worth the extra lines.
