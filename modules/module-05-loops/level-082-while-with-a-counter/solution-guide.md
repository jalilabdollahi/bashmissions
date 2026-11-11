# Walkthrough: while with a Counter

## The plan
Two numbers move forward together: the week number goes up by 1 and the size goes up by 25. A `while` loop lets you control both, and its test decides when to stop.

## Step by step
1. Handle the missing argument first: usage on stderr, `exit 2`.
2. Set the starting state before the loop: `week=1` and `size=100`. Keep the argument in a named variable too, `weeks=$1`, because the loop will read it many times.
3. Open the loop with `while (( week <= weeks )); do`. The double parentheses evaluate an arithmetic test. When `week` passes `weeks`, the test is false and the loop ends.
4. In the body: add 25 to the size, print the line, then advance the counter with `week=$(( week + 1 ))`.
5. Close with `done`.

## Complete solution

```bash
#!/usr/bin/env bash
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh WEEKS" >&2
  exit 2
fi

weeks=$1
week=1
size=100
while (( week <= weeks )); do
  size=$(( size + 25 ))
  echo "week $week: $size GB"
  week=$(( week + 1 ))
done
```

## Trying it by hand
`bash solution.sh 4`. Then comment out the `week=...` line and run it and be ready to press Ctrl-C: it will print forever. That is the classic while-loop bug, and it is good to see it once on purpose.

## An alternative
`for (( week=1; week<=weeks; week++ ))` does the same with the counter built into the header. It is shorter when only one counter is involved. `while` wins when the condition is about something other than a plain count, which is the topic of the next levels.
