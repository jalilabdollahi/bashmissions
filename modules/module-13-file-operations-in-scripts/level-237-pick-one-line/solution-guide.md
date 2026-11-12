# Walkthrough: Pick One Line

## The plan

Validate the inputs, ask `sed` for exactly one line, and treat "nothing came
back" as the error case.

## Step by step

The day goes into a `sed` command, so it must be a plain positive integer.
A regex test in `[[ ]]` does the job in one go, together with the argument
count:

```bash
if [[ $# -ne 2 || ! $2 =~ ^[1-9][0-9]*$ ]]; then
  echo "usage: solution.sh ROTA DAY" >&2
  exit 2
fi
```

`^[1-9][0-9]*$` means: starts with 1-9, then any digits, nothing else. That
rejects `0`, `monday`, `-3` and `2x`.

Now the extraction. `sed` reads a file line by line and prints each one by
default. `-n` turns that off. An address in front of a command (here the
line number) restricts the command to that line, and `p` means print:

```bash
name=$(sed -n "${day}p" "$rota")
```

The double quotes let `$day` expand; with single quotes sed would receive the
literal text `${day}p`.

If the file is shorter than `day`, sed prints nothing and succeeds. So the
check is on the *result*:

```bash
if [[ -z $name ]]; then
  echo "no one on call for day $day" >&2
  exit 1
fi
```

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 || ! $2 =~ ^[1-9][0-9]*$ ]]; then
  echo "usage: solution.sh ROTA DAY" >&2
  exit 2
fi
rota=$1
day=$2
[[ -r $rota ]] || { echo "cannot read $rota" >&2; exit 1; }

name=$(sed -n "${day}p" "$rota")
[[ -n $name ]] || { echo "no one on call for day $day" >&2; exit 1; }
echo "day $day: $name"
```

## Try it by hand

```bash
printf 'Mara\nTheo\nPriya\n' > rota.txt
./solution.sh rota.txt 3
./solution.sh rota.txt 4; echo "exit $?"
```

## An alternative

`head -n "$day" file | tail -n 1` also picks line N, with two processes
instead of one. It prints the *last* line when the file is too short,
which would give a wrong name for day 9 of a 2-line file: a silent bug.
`sed -n` prints nothing, which is easy to detect.
