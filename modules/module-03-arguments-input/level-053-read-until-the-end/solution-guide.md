# Walkthrough: Read Until the End

## The plan
Run the same small job (count a line, add its cost) once per input line, however
many lines there are, and report when the input ends.

## Building it
Two counters, initialised before the loop so they exist even for empty input:

```bash
items=0
total=0
```

`while` runs its body as long as its condition command succeeds. `read` succeeds
when it got a line and fails at end of input (EOF), so it is the perfect
condition. Giving it two names splits each line into item and cost (level 47):

```bash
while read -r name cost; do
  items=$((items + 1))
  total=$((total + cost))
done
```

`$(( ... ))` does integer arithmetic, and it accepts bare variable names, so
`cost` needs no dollar sign inside.

**The edge case.** If the paste ends without a newline (`... fan 8` and EOF),
`read` fills `name` and `cost` but still returns failure, and the last line would
be dropped. Allow one more turn when `cost` has content:

```bash
while read -r name cost || [[ -n $cost ]]; do
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
items=0
total=0
while read -r name cost || [[ -n $cost ]]; do
  items=$((items + 1))
  total=$((total + cost))
done
echo "items=$items total=$total"
```

## Try it by hand
```bash
printf 'usb-cable 12\nswitch 340\n' | ./solution.sh
printf 'ssd 120\nfan 8' | ./solution.sh      # no final newline
./solution.sh < /dev/null
```

## Alternative
`awk '{n++; s+=$2} END {print ...}'` is shorter for this exact job, but a Bash
loop is the tool when each line needs several Bash commands (checks, function
calls, file operations).
