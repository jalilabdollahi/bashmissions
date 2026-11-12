# Walkthrough: Append Entries

## The plan

A log is a file that only grows. Each run must (1) compute a timestamp,
(2) write one line at the end, and (3) leave everything older untouched.

## Step by step

The arguments: the first is the level, the rest is the sentence. `shift`
removes `$1` and renumbers the rest, so afterwards `"$@"` holds just the
message words, and `"$*"` joins them with single spaces.

```bash
level=$1
shift
```

The timestamp comes from `date` with a format string. The `+` introduces the
format; `%Y` year, `%m` month, `%d` day, `%H` hour (24h), `%M` minutes, `%S`
seconds:

```bash
stamp=$(date '+%Y-%m-%d %H:%M:%S')
```

Appending is the single character difference between `>` and `>>`:

```bash
echo "[$stamp] $level: $*" >> ops.log
```

Finally `cat ops.log` shows the history.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 ]]; then
  echo "usage: solution.sh LEVEL MESSAGE..." >&2
  exit 2
fi
level=$1
shift
stamp=$(date '+%Y-%m-%d %H:%M:%S')
echo "[$stamp] $level: $*" >> ops.log
cat ops.log
```

## Try it by hand

```bash
./solution.sh INFO "first entry"
./solution.sh WARN second entry without quotes
```

Both work: `"$*"` glues the separate words back together.

## An alternative

You could compute `printf '[%s] %s: %s\n' ...` for stricter control over
what is written, and that is the better habit when the message may begin
with a dash or contain backslashes, because `echo` can interpret those.
For a plain sentence the `echo` version is shorter and easier to read.

## Reading the result

Run the script three times and look at `ops.log` with `cat -n ops.log`:
three numbered lines, oldest at the top. Because the layout starts with the
year and goes down to the second, `sort ops.log` would keep them in time
order too, which is why timestamps are written big unit first. If you ever
see only one line after several runs, a `>` has crept in where `>>` belongs.
