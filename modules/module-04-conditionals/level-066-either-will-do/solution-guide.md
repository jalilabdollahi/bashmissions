# Walkthrough: Either Will Do

## The plan

Three reasons lead to the same outcome. When several reasons share one result,
join them with "or" in one condition rather than copying the same `echo` into
three branches.

## Building it

Start with named arguments:

```bash
day="$1"
holiday="$2"
```

Now the condition. `||` between comparisons means "or", and `[[ ]]` allows
as many as you like. Every operand is a complete comparison:

```bash
if [[ $day == sat || $day == sun || $holiday == yes ]]; then
  echo "weekend rota: Mara has the pager"
else
  echo "weekday rota: Theo has the pager"
fi
```

Read it aloud: "if the day is Saturday or the day is Sunday or it is a holiday,
use the weekend rota". If you can say the runbook sentence and the code in the
same words, you wrote it well.

Bash evaluates the tests left to right and stops at the first true one. A
Saturday holiday does not need the third test, and the answer is the same
either way.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

day="$1"
holiday="$2"

if [[ $day == sat || $day == sun || $holiday == yes ]]; then
  echo "weekend rota: Mara has the pager"
else
  echo "weekday rota: Theo has the pager"
fi
```

## Try it by hand

```bash
./solution.sh sat no
./solution.sh wed yes
./solution.sh mon no
```

## An alternative

A `case` statement could group `sat|sun` neatly, but the holiday flag is a
second variable, which `case` cannot test at the same time. `||` handles
conditions that mix different variables. You meet `case` in level 73.
