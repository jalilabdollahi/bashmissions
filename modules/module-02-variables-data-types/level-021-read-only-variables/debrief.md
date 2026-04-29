# Read-Only Variables

`readonly` (or its synonym `declare -r`) marks a variable as **immutable** for the lifetime of the shell. Any later attempt to reassign or `unset` it triggers an error.

```bash
readonly VERSION="1.0.0"
VERSION="2.0.0"      # bash: VERSION: readonly variable
unset VERSION        # bash: unset: VERSION: cannot unset: readonly variable
```

Why use it:

- Lock down config values you read once at the top of a script and never want to mutate.
- Make assumptions explicit — if downstream code accidentally sets the variable, the script aborts loudly rather than silently using a wrong value.
- Pair with `declare -r` to combine immutability with other attributes: `declare -ri MAX=100` (readonly integer).

Important behaviours:

- Failed reassignment under `set -e` aborts the script — and `|| true` alone is **not** enough, because Bash treats readonly violations as a special fatal error. Wrap the attempt in a subshell: `( NAME=x ) 2>/dev/null || true`. The subshell isolates the failure as a regular non-zero exit that `||` can catch.
- `readonly` is per-shell; subprocesses don't inherit the readonly attribute (they get a fresh copy).
- There's no "unreadonly". Once readonly, the variable stays readonly until the shell exits.

```bash
readonly NAME="$1"
( NAME="changed" ) 2>/dev/null || true
echo "$NAME"   # still the original
```
