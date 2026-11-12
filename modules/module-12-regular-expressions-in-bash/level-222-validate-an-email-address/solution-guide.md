# Walkthrough: Validate an Email Address

## The plan
An address has a fixed skeleton: `local @ domain . extension`. Translate each
part into a class and a count, join them, and anchor the whole thing.

## The parts
| part | regex | notes |
|---|---|---|
| start | `^` | nothing may come before |
| local part | `[[:alnum:]._%+-]+` | one or more of the allowed characters; the dash is last so it is not read as a range |
| at sign | `@` | exactly one; the local class does not contain `@` so a second one cannot hide there |
| domain | `[[:alnum:].-]+` | letters, digits, dots, dashes |
| last dot | `\.` | escaped so it is a real dot |
| extension | `[[:alpha:]]{2,}` | at least two letters |
| end | `$` | nothing may come after |

## How the domain and the dot get along
The domain class also contains the dot, so it is greedy and first swallows
everything to the end of the line. The engine then *backs off* character by
character until `\.[[:alpha:]]{2,}$` fits. For `harbour-bakery.co.uk` it
settles with `harbour-bakery.co` as domain, `.uk` as extension.

## Why the junk fails
`noor@lanternfish` has no dot for `\.` to use, `noor@@x.io` has a second `@` the
domain class refuses, `noor @x.io` has a space that no class contains, and
`x.c` has a one-letter extension.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
re='^[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]{2,}$'
while IFS= read -r addr || [[ -n $addr ]]; do
  if [[ $addr =~ $re ]]; then
    echo "OK $addr"
  else
    echo "BAD $addr"
  fi
done
```

## Try it by hand
```bash
printf 'noor@lanternfish.example\nnoor@localhost\n' | ./solution.sh
```

## Alternative
Check for `*@*.*` with a glob. It is shorter, and it also accepts `@.`, spaces and
`a@b@c.d`. The regex costs one line more and rejects them.
