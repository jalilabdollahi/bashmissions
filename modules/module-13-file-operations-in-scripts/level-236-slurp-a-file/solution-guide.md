# Walkthrough: Slurp a File

## The plan

"Slurping" means pulling a whole file into memory at once, here into one
shell variable. After that the token is just a string, and the string tools
from earlier modules do the rest.

## Step by step

First guard against bad input. A missing file would otherwise give a cryptic
shell error and, in the worst case, an empty token that looks valid:

```bash
if [[ ! -f $file || ! -r $file ]]; then
  echo "cannot read $file" >&2
  exit 1
fi
```

Then the slurp itself:

```bash
token=$(<"$file")
```

Read `$( )` as "run this and capture the output". Normally there is a command
inside; here there is only `<"$file"`, a redirection with no command. Bash
treats that as "output the file's content". It is faster than `$(cat file)`
because no second process is started.

One detail: command substitution removes **all** trailing newlines, so the
final `\n` (and any blank lines after it) never reaches the variable. That is
why the length of `abc\n\n\n` is 3.

Now the string work: `${#token}` is the length, `${token:0:4}` the first
four characters (or fewer if the token is shorter).

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then echo "usage: solution.sh FILE" >&2; exit 2; fi
file=$1
if [[ ! -f $file || ! -r $file ]]; then
  echo "cannot read $file" >&2
  exit 1
fi
token=$(<"$file")
echo "length=${#token}"
echo "masked=${token:0:4}****"
```

## Try it by hand

```bash
printf 'abcdef123\n\n' > t.txt
./solution.sh t.txt
```

## An alternative

`token=$(cat "$file")` gives the same text. It works everywhere, including
`sh`, but launches an extra process. `$(<file)` is Bash-specific; since we
already depend on Bash, take the shorter, quicker form. Note that both forms
are only meant for small files: the entire content is held in memory.
