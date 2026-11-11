# Walkthrough: Default Parameters

## The plan
Each parameter gets a sensible fallback. The function stays callable with fewer
arguments, and the script, which runs with `set -u`, never trips over a missing
`$1`.

## Building it
The `:-` operator in `${var:-default}` substitutes the default when the variable
is unset *or* empty. Positional parameters are variables too:

```bash
retention_line() {
  local days=${1:-30}
  local tier=${2:-standard}
  echo "keep backups for $days days ($tier tier)"
}
```

Copying into named locals first makes the last line readable. The caller just
forwards what it has:

```bash
retention_line "$@"
```

`"$@"` expands to each original argument, still separate. When there are none, it
expands to nothing, so the function sees an empty `$1` and uses the default.

Why does the empty-string test case use the default? Because `:-` treats empty like
missing. (`${1-30}` without the colon would only fall back when unset.)

## Complete solution
```bash
#!/usr/bin/env bash
set -u
retention_line() {
  local days=${1:-30}
  local tier=${2:-standard}
  echo "keep backups for $days days ($tier tier)"
}
retention_line "$@"
```

## Try it by hand
```bash
./solution.sh
./solution.sh 90
./solution.sh "" premium
```

## Alternative
Use `local days=30; [[ $# -ge 1 ]] && days=$1`. It is more typing and does not treat
an empty string as missing. `:-` says what you mean in one line.
