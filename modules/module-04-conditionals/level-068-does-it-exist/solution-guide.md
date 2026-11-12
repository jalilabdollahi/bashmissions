# Walkthrough: Does It Exist?

## The plan

Four possible answers and one path: a ladder again, but this time the tests
look at the file system rather than at strings. Three file tests do the work:

| Test | True when |
|---|---|
| `-e path` | anything exists at the path |
| `-f path` | it is a regular file |
| `-d path` | it is a directory |

## Building it

The order of the ladder is the important design decision. `-e` is true for
files and for directories and for devices and for sockets. If you asked it
first, you could never tell the specific kinds apart. So ask the specific
questions first and keep `-e` for the leftovers:

```bash
path="$1"
if [[ -f $path ]]; then
  echo "$path: regular file"
elif [[ -d $path ]]; then
  echo "$path: directory"
elif [[ -e $path ]]; then
  echo "$path: something else"
else
  echo "$path: not found"
fi
```

Inside `[[ ]]` an unquoted variable is safe even with spaces, so the test
works for `old reports/q1 totals.csv`. The `echo` lines are different: the
path is quoted there by being inside double quotes.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

path="$1"

if [[ -f $path ]]; then
  echo "$path: regular file"
elif [[ -d $path ]]; then
  echo "$path: directory"
elif [[ -e $path ]]; then
  echo "$path: something else"
else
  echo "$path: not found"
fi
```

## Try it by hand

```bash
touch demo.txt; mkdir demo-dir
./solution.sh demo.txt
./solution.sh demo-dir
./solution.sh /dev/null
./solution.sh nope
```

## An alternative

`ls "$path"` and checking its exit status also detects existence, but it prints
noise and cannot distinguish files from directories. The built-in tests are
faster, quieter and say exactly what they mean.
