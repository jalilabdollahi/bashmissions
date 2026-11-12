# Walkthrough: Strip a Prefix

## The plan
Describe what the unwanted front part looks like ("anything, then `://`") and
let Bash delete the shortest piece that fits.

## How the pattern works
Patterns in parameter expansions are glob patterns, the same family you use with
`ls *.log`. `*` means "any characters, including none". So `*://` means "anything
followed by `://`".

`${url#*://}` removes the **shortest** prefix of `$url` that matches. Take the
redirect link:

```
https://login.example/go?next=http://tidewater.example/books
```

The candidates that match `*://` are `https://` and also the much longer
`https://login.example/go?next=http://`. A single `#` picks the first, shortest
one, so the second address is kept.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
url=$1
echo "${url#*://}"
```

## Edge cases
- No `://` at all: the pattern cannot match, so the value is returned unchanged.
- `https://` alone: the entire value is the prefix, so the result is empty.

## Try it by hand
```bash
./solution.sh "https://login.example/go?next=http://tidewater.example/books"
./solution.sh gull-anchor.example/pub
```

## Alternative
`echo "$url" | sed 's|^[a-z]*://||'` also works, but it spawns two processes and
needs a regex to say "letters only". With `${url#*://}` there is nothing to
escape, nothing to spawn, and it keeps working inside a loop that handles
thousands of lines.
