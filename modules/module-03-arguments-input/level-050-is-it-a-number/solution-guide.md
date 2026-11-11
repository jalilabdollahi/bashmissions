# Walkthrough: Is It a Number?

## The plan
Describe what a good value looks like (digits only), test the argument against
that description, and bail out with an error if it fails.

## Building it
The description is a regular expression: `^[0-9]+$`.

- `^` anchors at the start, `$` at the end. Without them, `5O` would match
  because it *contains* a digit.
- `[0-9]` is any one digit.
- `+` means one or more of the previous item.

In Bash the test is `[[ value =~ pattern ]]`. It succeeds when the pattern matches.
We want to react when it does **not**, so negate it with `!`:

```bash
[[ ! $quota =~ ^[0-9]+$ ]] && { echo "error: not a whole number: $quota" >&2; exit 1; }
```

The braces, `>&2` and `exit` follow the guard pattern from level 43. This time
the exit status is 1 because the *value* is bad, not the usage of the command.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
quota=$1
[[ ! $quota =~ ^[0-9]+$ ]] && { echo "error: not a whole number: $quota" >&2; exit 1; }
echo "quota set to $quota GB"
```

## Try it by hand
```bash
./solution.sh 250
./solution.sh 5O ; echo "status=$?"
./solution.sh 2.5
./solution.sh -10
```
For `-10` the dash is not a digit, so it is rejected. (Passing it as an argument
works because the script does not parse options.)

## Alternative
`case $quota in *[!0-9]*) ...` is the old portable idiom and works in plain
`sh`. The `=~` form says what you mean ("digits from start to end") and reads
better for anything more complicated than digits.
