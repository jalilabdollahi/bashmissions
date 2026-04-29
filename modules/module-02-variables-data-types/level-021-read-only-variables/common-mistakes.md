# Common Mistakes for Read-Only Variables

- Forgetting that `set -e` kills the script on a failed readonly reassignment, and that `NAME=x 2>/dev/null || true` (no subshell) does **not** help — Bash treats this violation as fatal and skips the `||`. Wrap in a subshell: `( NAME=x ) 2>/dev/null || true`.

- Trying to `unset` a readonly variable. It can't be done — `unset` itself fails. The variable lives until the shell exits.

- Putting `readonly` after the assignment: `NAME="x"; readonly NAME` works, but `readonly NAME="x"` is the canonical one-liner.

- Confusing `readonly` with `local`. `local` scopes a variable to a function; `readonly` makes it immutable. They're orthogonal — you can have a `local readonly`.

- Spelling: `readonly` is one word, no hyphen. `read-only` won't work.
