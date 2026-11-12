# Walkthrough: Return a Status

## The plan
Three bands, three numbers. The function decides, the script reports and passes
the same number up to whoever launched it (cron, in Priya's case).

## Building it
`return` leaves the function immediately and sets its exit status. Check the
highest threshold first so each range is reached only when the bigger one fails:

```bash
check_disk() {
  local pct=$1
  if (( pct >= 95 )); then
    return 2
  elif (( pct >= 80 )); then
    return 1
  fi
  return 0
}
```

The status lands in `$?`. Copy it into a variable at once, because every
command, even `echo`, resets `$?`:

```bash
check_disk "$1"
code=$?
echo "disk $1% -> status $code"
exit "$code"
```

Without `set -e` the non-zero return does not abort the script. (With `set -e`
you would write `check_disk "$1" || code=$?`; later levels use that style.)

## Complete solution
```bash
#!/usr/bin/env bash
check_disk() {
  local pct=$1
  if (( pct >= 95 )); then return 2
  elif (( pct >= 80 )); then return 1
  fi
  return 0
}
check_disk "$1"
code=$?
echo "disk $1% -> status $code"
exit "$code"
```

## Try it by hand
```bash
./solution.sh 97; echo "shell saw $?"
./solution.sh 12; echo "shell saw $?"
```

## Alternative
You could print the word `ok` or `full` from the function and capture that text.
That works, but a status code is what `if`, `&&` and cron understand natively,
which is the topic of the next level.
