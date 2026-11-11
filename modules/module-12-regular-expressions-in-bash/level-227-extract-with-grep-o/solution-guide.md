# Walkthrough: Extract with grep -o

## The plan
1. `grep -o -E` prints the matched text only.
2. `sort -u` orders the matches and removes duplicates.
3. Make an empty result a success.

## The regex
An address is four numbers joined by three dots. A good way to say that is
"`n.` three times, then `n`":

```
([0-9]{1,3}\.){3}[0-9]{1,3}
```

`([0-9]{1,3}\.)` is one group (a number and its dot), `{3}` repeats the whole
group three times, and the last `[0-9]{1,3}` is the final number. The dot is
escaped so it means a real dot.

`version 2.14.3` has only three numbers and `3.14` only two, so neither fits. A
line with several addresses yields one output line per address, which is what
`-o` is for.

## The pipeline and pipefail
`grep` returns 1 when there is no match, and `pipefail` would make the whole
pipeline fail even though `sort` is perfectly happy. So the grep call is
grouped: `{ grep ... || true; } | sort -u`.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh LOGFILE" >&2
  exit 2
fi
{ grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' "$1" || true; } | sort -u
```

## Try it by hand
```bash
echo 'from 10.1.2.3 via 10.1.2.3 to 172.16.0.9' | ./solution.sh /dev/stdin
```

## Alternative
A Bash loop with `while [[ $rest =~ $re ]]` and `rest=${rest#*"${BASH_REMATCH[0]}"}`
can extract several matches per line too, but it is long and slow. `grep -o` is
exactly this loop, written in C.
