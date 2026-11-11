# Walkthrough: Assertions

## The plan
`assert_eq` is a three-argument function with two possible outcomes, each with its
own stream and its own status. Stdout and status 0 mean "all is well"; stderr
and status 1 mean "here is exactly what differed".

## Step by step
1. Give the arguments names. A line like `local expected=$1 actual=$2 label=$3`
   makes the rest readable and keeps the variables inside the function.

2. Compare as strings inside `[[ ]]`:

   ```bash
   if [[ $actual == "$expected" ]]; then
   ```

   Inside `[[ ]]` the left side needs no quotes, but the right side does: an
   unquoted right side is a glob pattern, so `a*` would match `abc` and a typo
   could pass as correct.

3. On success print the PASS line and `return 0`.

4. On failure write the message to stderr with both values in single quotes and
   `return 1`. Seeing `expected '8080' but got '8081'` is the point: the next
   person fixes the problem without rerunning anything.

5. The script's last command is the call itself, so Bash exits with the
   function's status.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
assert_eq() {
  local expected=$1 actual=$2 label=$3
  if [[ $actual == "$expected" ]]; then
    echo "PASS: $label"
    return 0
  fi
  echo "FAIL: $label: expected '$expected' but got '$actual'" >&2
  return 1
}
assert_eq "$1" "$2" "$3"
```

## Try it by hand
```bash
./solution.sh 42 42 answer; echo "status=$?"
./solution.sh 8080 8081 "web port"; echo "status=$?"
./solution.sh 'a*' abc star; echo "status=$?"
```

## Alternative
`[ "$a" = "$b" ]` also compares strings and works in plain sh. `[[ ]]` is
preferred in Bash scripts: it needs fewer quotes on the left and has no word
splitting surprises.
