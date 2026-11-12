# Walkthrough: Read into an Array

## The plan
The tags can be one or ten, so separate variables will not do. An array holds a
list of any length. `read -a` fills one directly from a line of input.

## Building it
First, the splitting rule. By default `read` cuts on spaces and tabs; our tags use
commas. Setting `IFS` right in front of the command changes it for that command
only, nothing else in the script is affected:

```bash
IFS=, read -ra tags
```

Now `tags` is an array. For the input `web,eu-west,critical`:

| expression | meaning | value |
|---|---|---|
| `${tags[0]}` | first element | web |
| `${tags[-1]}` | last element | critical |
| `${#tags[@]}` | number of elements | 3 |

(Negative indexes need Bash 4.3 or newer; the game's Bash is newer than that.)

```bash
echo "count=${#tags[@]} first=${tags[0]} last=${tags[-1]}"
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=, read -ra tags
echo "count=${#tags[@]} first=${tags[0]} last=${tags[-1]}"
```

## Try it by hand
```bash
echo "web,eu-west,critical" | ./solution.sh
echo "database" | ./solution.sh
```

## Alternative
You could read the whole line into one string and cut it with `cut -d,` for each
field, but you would not know how many fields exist. Arrays are the natural fit
for "a list of unknown length", and module 9 covers them in depth.
