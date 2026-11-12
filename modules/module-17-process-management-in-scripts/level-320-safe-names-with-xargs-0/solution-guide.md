# Walkthrough: Safe Names with xargs -0

## The plan

Every tool in the chain must agree on a separator that cannot appear in the
data. Newline and space can appear in a Unix file name; so can quotes, `*` and
`$`. The only byte that cannot is NUL (byte value zero). `find -print0` and
`xargs -0` both speak NUL, so file names pass through untouched.

## Step by step

First see what goes wrong. Plain `find | xargs cksum` sends one name per line.
xargs then splits on blanks and tries to interpret `'` and `"`: `web 1.log`
turns into `web` and `1.log`, and `it's.log` makes xargs complain about an
unmatched single quote. Your script would fail on exactly the files that
people make by accident.

The fix has two halves:

```bash
find "$dir" -type f -name '*.log' -print0 | xargs -0 cksum | sort
```

- `-type f` keeps regular files, so the folder `old.log/` is skipped but
  `old.log/real.log` inside it is found.
- `-name '*.log'` is quoted, so the shell leaves the `*` for find to expand.
- `-print0` ends each name with NUL.
- `xargs -0` splits on NUL only: no space splitting, no quote processing, no
  backslash processing. Every name arrives at `cksum` as exactly one argument.
- `sort` makes the output order independent of the order find walked the folder.

A file called `-dash.log` is safe too, because find prints it as
`archive/-dash.log` (starting with the folder), which can not look like an option.

The script only adds argument and folder checks before that line.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh DIR" >&2
  exit 2
fi
dir=$1

if [[ ! -d $dir ]]; then
  echo "not a folder: $dir" >&2
  exit 1
fi

find "$dir" -type f -name '*.log' -print0 | xargs -0 cksum | sort
```

## Try it by hand

```bash
mkdir -p logs && echo hi > "logs/Gull & Anchor.log" && echo yo > "logs/it's.log"
./solution.sh logs
find logs -type f | xargs cksum      # watch it break
```

## An alternative

`find "$dir" -type f -name '*.log' -exec cksum {} +` also handles every name
safely and needs no xargs at all. `xargs` is the better choice when you need
`-P` for parallelism or want to combine it with other tools in the pipe.
