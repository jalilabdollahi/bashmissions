# Walkthrough: Arguments or stdin

## The plan
The value can arrive from two places, and there is a priority: the argument if
given, otherwise stdin. After trying both, verify that something arrived.

## Building it
**Step 1: the argument, safely.** Plain `$1` crashes under `set -u` when nothing
was passed. `${1:-}` means "`$1`, or empty if it is missing":

```bash
host=${1:-}
```

**Step 2: the fallback.** Only when `host` is still empty do we consume stdin.
The braces let us add `|| true` for the end-of-file case (level 51):

```bash
[[ -z $host ]] && { read -r host || true; }
```

Because the read sits behind the guard, an argument is never "stolen" from stdin:
stdin stays unread, which matters in pipelines.

**Step 3: refuse an empty result.** Whatever route we took, the value must exist:

```bash
[[ -z $host ]] && { echo "usage: solution.sh [HOSTNAME]" >&2; exit 2; }
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
host=${1:-}
[[ -z $host ]] && { read -r host || true; }
[[ -z $host ]] && { echo "usage: solution.sh [HOSTNAME]" >&2; exit 2; }
echo "checking $host"
```

## Try it by hand
```bash
./solution.sh anchovy
echo dory | ./solution.sh
./solution.sh < /dev/null; echo "status=$?"
```

## Alternative
`host=${1:-$(cat)}` also falls back to stdin, but `cat` would read ALL input
instead of one line, and it would wait for input even when the argument exists
if you wrote it as a separate statement. The explicit version is easier to adapt.
