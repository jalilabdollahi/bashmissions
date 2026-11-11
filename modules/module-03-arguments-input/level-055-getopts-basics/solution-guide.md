# Walkthrough: getopts Basics

## The plan
Same shape as the long-flag parser: defaults, a loop over options, then the real
work. The difference is that `getopts` does the walking, so no `shift` and no
`$#` test.

## Building it
Defaults:

```bash
count=3
verbose="no"
```

The option string `"vn:"` tells `getopts` that `-v` and `-n` exist and that `-n`
takes a value (the colon). Each time the loop condition runs, `opt` receives the
next option letter:

```bash
while getopts "vn:" opt; do
  case $opt in
    v) verbose="yes" ;;
    n) count=$OPTARG ;;
  esac
done
```

`$OPTARG` is where `getopts` stores the value that followed `-n`. Bundles such as
`-vn 2` are split for you: `v` first, then `n` with value `2`.

After the loop, the work. The header is printed only when verbose is on, and
`head` copies from stdin:

```bash
[[ $verbose == "yes" ]] && echo "showing first $count lines"
head -n "$count"
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
count=3
verbose="no"
while getopts "vn:" opt; do
  case $opt in
    v) verbose="yes" ;;
    n) count=$OPTARG ;;
  esac
done
[[ $verbose == "yes" ]] && echo "showing first $count lines"
head -n "$count"
```

## Try it by hand
```bash
printf 'a\nb\nc\nd\n' | ./solution.sh
printf 'a\nb\nc\nd\n' | ./solution.sh -vn 2
```

## Alternative
The hand-written `while`/`case`/`shift` loop from level 54 can parse the same
options, and is the only way to support `--long` names. For short options
`getopts` is shorter and understands bundling and `--` for free.
