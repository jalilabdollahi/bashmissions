# Walkthrough: Capitalize Words

## The plan
Split the name into words, fix the case of each word, and glue them together with
single spaces.

## Splitting
When a variable is used **without quotes** in a `for` list, Bash splits it on
whitespace (spaces, tabs, newlines) and drops the extra blanks. Normally that is a
classic bug; here it is the feature we want:

```bash
for word in $name; do
```

`"  old harbour  books "` yields exactly three words, and the stray spaces vanish.
For an empty name the loop never runs.

## Fixing one word
First flatten the word to lower case, then raise only its first letter:

```bash
word=${word,,}
echo "${word^}"
```

`${word^}` has a single caret: it changes the first character only.

## Building the result
Append each fixed word to `result`. To avoid a leading space, add the space only
when `result` already holds something. `${result:+ }` expands to a space if
`result` is non-empty, and to nothing otherwise (the `:+` form from the
variables module).

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
name=${1-}
result=""
for word in $name; do
  word=${word,,}
  result+="${result:+ }${word^}"
done
echo "$result"
```

## Try it by hand
```bash
./solution.sh "NORTH PIER dental"
./solution.sh "gull  &  anchor pub"
```

## Alternative
Hand each word to `awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}'`.
It works, but runs a process for the whole job and the logic is harder to read
than two expansions.
