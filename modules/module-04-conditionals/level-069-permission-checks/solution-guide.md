# Walkthrough: Permission Checks

## The plan

First rule out the path that is not there. Then ask three independent
questions and record each answer as a single character. A file can have any of
the eight combinations of rights, so a ladder (which picks exactly one branch)
is the wrong shape; we need three separate `if` blocks instead.

## Building it

Guard against the missing path first, with the guard-clause style from the
earlier level:

```bash
path="$1"
if [[ ! -e $path ]]; then
  echo "no such file: $path" >&2
  exit 1
fi
```

Now the three tests. Start each character as `-` (the "no" answer) and
overwrite it when the test passes:

```bash
r="-"
w="-"
x="-"
if [[ -r $path ]]; then r="r"; fi
if [[ -w $path ]]; then w="w"; fi
if [[ -x $path ]]; then x="x"; fi
```

Finally glue the three characters together. No spaces between `$r$w$x`, so they
form one string, exactly like the permission column of `ls -l`:

```bash
echo "$path: $r$w$x"
```

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

path="$1"

if [[ ! -e $path ]]; then
  echo "no such file: $path" >&2
  exit 1
fi

r="-"
w="-"
x="-"

if [[ -r $path ]]; then r="r"; fi
if [[ -w $path ]]; then w="w"; fi
if [[ -x $path ]]; then x="x"; fi

echo "$path: $r$w$x"
```

## Try it by hand

```bash
printf '#!/bin/sh\n' > t.sh; chmod 755 t.sh; ./solution.sh t.sh
chmod 000 t.sh;             ./solution.sh t.sh
```

## An alternative

You could parse `ls -l` and slice out the mode string. That reports the
file's mode bits for owner, group and others, not what *you* can do, and `ls`
output is meant for people, not scripts. `-r -w -x` ask the system directly.
