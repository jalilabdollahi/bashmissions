# Walkthrough: A DEBUG Switch

## The plan
Production wants silence, debugging wants detail, and editing the script on a
live server is out of the question. The usual answer is a switch in the
environment: `DEBUG=1 ./solution.sh eel 3`. A small function reads it so
that the rest of the script can say `debug "..."` without caring.

## Step by step
1. Write the function. Three details make it solid:

   ```bash
   debug() {
     if [[ ${DEBUG:-} == 1 ]]; then
       echo "debug: $*" >&2
     fi
   }
   ```

   - `${DEBUG:-}` expands to an empty string when DEBUG does not exist. Without
     the `:-`, `set -u` would abort the script with "unbound variable" on every
     normal run.
   - The message goes to stderr (`>&2`), so stdout stays clean for the real
     result.
   - A full `if` returns status 0 when the test is false. The shorter
     `[[ ... ]] && echo ...` would return 1, and with `set -e` a function that
     ends with a failing command stops the whole script.

2. Call it at the places where you would otherwise have to guess:

   ```bash
   debug "sites=$2"
   first=8000
   last=$(( first + 2 * $2 - 1 ))
   debug "last=$last"
   ```

3. Try both modes:

   ```
   $ ./solution.sh marlin 2
   marlin uses ports 8000-8003
   $ DEBUG=1 ./solution.sh marlin 2
   debug: sites=2
   debug: last=8003
   marlin uses ports 8000-8003
   ```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
debug() {
  if [[ ${DEBUG:-} == 1 ]]; then
    echo "debug: $*" >&2
  fi
}
debug "sites=$2"
first=8000
last=$(( first + 2 * $2 - 1 ))
debug "last=$last"
echo "$1 uses ports $first-$last"
```

## Try it by hand
```bash
./solution.sh eel 3
DEBUG=1 ./solution.sh eel 3
DEBUG=0 ./solution.sh eel 3
```

## Alternative
`[[ -n ${DEBUG:-} ]]` treats any non-empty value as "on", including `DEBUG=0`,
which surprises people. Comparing with `1` is more predictable.
