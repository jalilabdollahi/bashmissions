# Debrief: One-Line Decisions

`A && B || C` is a shorthand that fits in a single line and passes for an
if/else. It is everywhere in shell scripts, in docs, and on forums, and it
works until B fails. Understanding why is a rite of passage.

## Under the hood

`&&` and `||` have equal precedence and group from the left, so the line is
evaluated as `(A && B) || C`. The final status of `A && B` is B's status if A
passed, or A's failing status if it did not. Then `||` looks only at that
status and cannot tell which of the two commands produced it. A real
`if A; then B; else C; fi` is different: C is attached to A's result, not B's.

The fixes: guarantee that B succeeds (for example `B || true`, or the brace
group used here), or use `if`. Also be aware that under `set -e` the exit
status of a long chain can end the script when its last command fails, which
is one more reason to prefer `if` for anything that does real work.

## Where it shows up

`mkdir -p dir && cd dir`, `command -v tool || exit 1`, `[[ -f file ]] && source
file`, and defensive one-liners in Makefiles and CI definitions.

## Going further

You will use `command -v tool || { echo "missing"; exit 1; }` in the next level
to check that a program is installed before relying on it.
