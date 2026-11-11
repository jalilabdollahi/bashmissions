# Walkthrough: Find by Name

## The plan

Validate, run `find` with `-name`, sort what it says, count the lines.

## Step by step

`find` takes a starting point followed by *tests*. `-name` compares the
pattern with the **last component** of each path (the name, not the folder).
It uses shell wildcards: `*` any run of characters, `?` exactly one, `[ab]`
one of the listed.

```bash
find "$folder" -name "$pattern"
```

The quotes around `$pattern` are the heart of this level. If the user passes
`*.conf` and you write it unquoted, the shell expands it against the files
in the *current* folder before `find` starts. With one match in the current
folder, `find` receives `-name stray.conf` and silently searches for the
wrong thing; with two, it fails with a syntax error. Quoted, `find` gets
exactly the text `*.conf`.

`find` walks directories in whatever order the file system hands them over,
which differs between machines. Scripts that print results should end with
`| sort`.

Counting: if there are no matches, `echo "" | wc -l` would report one empty
line, so the zero case is handled separately:

```bash
matches=$(find "$folder" -name "$pattern" | sort)
if [[ -n $matches ]]; then
  echo "$matches"
  count=$(( $(echo "$matches" | wc -l) ))
else
  count=0
fi
echo "found: $count"
```

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "usage: solution.sh FOLDER PATTERN" >&2
  exit 2
fi
folder=$1
pattern=$2
[[ -d $folder ]] || { echo "no such folder: $folder" >&2; exit 1; }

matches=$(find "$folder" -name "$pattern" | sort)
if [[ -n $matches ]]; then
  echo "$matches"
  count=$(( $(echo "$matches" | wc -l) ))
else
  count=0
fi
echo "found: $count"
```

## Try it by hand

```bash
mkdir -p t/a t/b; touch t/a/x.conf t/b/y.conf t/z.txt
./solution.sh t '*.conf'
```

Try again with the quotes removed from `"$pattern"` inside the script while
the current folder holds two `.conf` files.

## An alternative

A bare glob such as `ls srv/*/*.conf` only reaches the depth you wrote,
and the bash option `shopt -s globstar` with `**` goes deeper but depends on
settings. `find` has no depth limit by default and names the tests it uses.
