# Walkthrough: One-Line Decisions

## The plan

The two operators `&&` and `||` chain commands by their exit status:

- `A && B` runs B only if A succeeded.
- `A || C` runs C only if A failed.

Put them together and `A && B || C` looks like "if A then B else C". It is
almost that, but not quite, and the difference is the whole point of this level.

## The trap

Bash reads `A && B || C` as `(A && B) || C`. C runs when `A && B` fails, and that
can happen in two ways: A failed (the case you meant) or A succeeded and B failed
(the case you forgot). With the pager down, `[[ $sev == critical ]]` succeeds, `notify`
fails, and the naive line then prints `logged: critical`. The incident is
quietly filed as "logged", which is the opposite of what the script should do.

## Building it

Make B incapable of failing. The braces group commands, and inside them the
pager call gets its own fallback:

```bash
{ notify page-oncall || echo "pager failed" >&2; }
```

If `notify` works, the group succeeds. If it fails, the fallback `echo` runs and
succeeds. Either way, the group's status is success, so the outer `||` is reached
only when the severity was not critical:

```bash
sev="${1:-}"
[[ $sev == critical ]] && { notify page-oncall || echo "pager failed" >&2; } || echo "logged: $sev"
```

Note the spaces after `{` and the `;` before `}`: braces are keywords and need
them.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

sev="${1:-}"

[[ $sev == critical ]] && { notify page-oncall || echo "pager failed" >&2; } || echo "logged: $sev"
```

## Try it by hand

```bash
./solution.sh critical
./solution.sh low
FAKE_NOTIFY_FAIL=1 ./solution.sh critical
```

## An alternative

The honest tool for a three-way outcome is a real `if`/`else`: no grouping
tricks, no hidden failure mode. Use the one-liner only when B is something that
cannot fail, such as `echo`, or when you have protected it as above.
