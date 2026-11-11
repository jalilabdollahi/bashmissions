# Walkthrough: Capture One Group

## The plan
Describe the phrase `Failed password for <user> from `, put parentheses around
the `<user>` part, and read it back from `BASH_REMATCH[1]`.

## The pattern
- `Failed password for ` and ` from ` are plain text (with their spaces) that
  anchor the pattern around the username.
- The username is "one word": `[^ ]+`, one or more characters that are not a
  space. Wrapped in parentheses: `([^ ]+)`.

```
Failed password for ([^ ]+) from 
```

The line `Failed password for invalid user admin from ...` has "invalid user admin"
between the two texts, which contains spaces, so the single word `[^ ]+` cannot
span it and the line does not match. That is the behaviour the objective asks for.

## After a match
`BASH_REMATCH` is an ordinary array that Bash fills on every successful `=~`:

| element | content |
|---|---|
| `[0]` | the whole matched text |
| `[1]` | the text matched by the first `( )` |

Read it inside the `if`. After a failed match the array is not something to rely
on.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
re='Failed password for ([^ ]+) from '
while IFS= read -r line || [[ -n $line ]]; do
  if [[ $line =~ $re ]]; then
    echo "${BASH_REMATCH[1]}"
  fi
done
```

## Try it by hand
```bash
echo 'sshd: Failed password for root from 203.0.113.9' | ./solution.sh
```

## Alternative
`sed -E 's/.*Failed password for ([^ ]+) from .*/\1/'` extracts the same word but
prints non-matching lines unchanged and starts a process per run. With `=~` the
decision and the extraction happen in one place, inside Bash.
