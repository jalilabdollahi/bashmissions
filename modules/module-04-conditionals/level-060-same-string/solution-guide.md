# Walkthrough: Same String?

## The plan

Two values go in, one of two sentences comes out. The only real question is how
to ask "are these identical?" safely, because the inputs are arbitrary text:
tags can contain spaces, capital letters and even a `*`.

## Building it

Name the arguments first. `expected` and `running` say more than `$1` and `$2`:

```bash
expected="$1"
running="$2"
```

The comparison uses `==` inside double brackets. One detail matters a great deal:
on the right-hand side of `==`, Bash interprets the text as a glob pattern unless
it is quoted. With an unquoted `$expected` holding `*`, everything would match.
Quote it and the comparison becomes literal:

```bash
if [[ $running == "$expected" ]]; then
```

The left side needs no quotes because `[[ ]]` does not split words or expand globs
on variables. Finish with the two messages:

```bash
  echo "in sync: $running"
else
  echo "DRIFT: expected $expected but found $running"
fi
```

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

expected="$1"
running="$2"

if [[ $running == "$expected" ]]; then
  echo "in sync: $running"
else
  echo "DRIFT: expected $expected but found $running"
fi
```

## Try it by hand

```bash
./solution.sh v1.0 v1.0
./solution.sh v1.0 V1.0
./solution.sh '*' anything
```

## An alternative

The old single-bracket form `[ "$a" = "$b" ]` also compares strings and works in
plain `sh`. It needs quotes on both sides, has no pattern surprises, and breaks
in odd ways if a variable is empty and unquoted. `[[ ]]` is safer in Bash scripts.
