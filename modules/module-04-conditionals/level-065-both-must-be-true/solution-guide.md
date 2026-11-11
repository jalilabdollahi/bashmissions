# Walkthrough: Both Must Be True

## The plan

Two requirements, one decision. We could nest one `if` inside another, but
Bash lets us state both in a single line with the "and" operator, `&&`. The
condition then reads exactly like Priya's whiteboard.

## Building it

Give the three arguments names; it makes the condition readable:

```bash
user="$1"
group="$2"
mfa="$3"
```

Join the two comparisons with `&&` inside one pair of double brackets:

```bash
if [[ $group == staff && $mfa == yes ]]; then
  echo "granted: $user"
else
  echo "denied: $user"
fi
```

The `else` branch covers all three failing combinations at once: wrong group,
no MFA, or both wrong. That is the strength of "and": you list what must be
true, and everything else is denied by default. This "deny unless proven
otherwise" shape is how security policies should be written.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

user="$1"
group="$2"
mfa="$3"

if [[ $group == staff && $mfa == yes ]]; then
  echo "granted: $user"
else
  echo "denied: $user"
fi
```

## Try it by hand

```bash
./solution.sh ana staff yes
./solution.sh ben staff no
./solution.sh cleo contractor yes
```

## An alternative

You can chain separate test commands with `&&`:
`if [[ $group == staff ]] && [[ $mfa == yes ]]; then`. It behaves the same and
is the only form that works with the single-bracket `[ ]` test. Inside one `[[ ]]`
it is shorter, and both sides are evaluated left to right.
