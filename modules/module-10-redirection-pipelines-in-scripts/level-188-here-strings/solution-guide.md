# Walkthrough: Here-Strings

## The plan

Two small jobs on the same string: count its words, shout it. Both `wc` and
`tr` read stdin, so we give them the string as stdin.

## Step by step

The long way is `echo "$text" | wc -w`: it starts an extra process just to
move a string into a pipe. The here-string does the same without it:

```bash
wc -w <<< "$text"
```

`<<<` takes ONE word (here the quoted variable) and makes it the standard
input, followed by a newline. Quote the variable, otherwise the shell splits
it at spaces first, and the double spaces in the tests would be lost in the
capitals line.

Word counting: `wc -w` counts runs of non-space characters, so leading and
repeated spaces are ignored, and an empty string gives 0. On macOS the number
comes padded with spaces, so wrapping it in arithmetic cleans it:

```bash
words=$(( $(wc -w <<< "$text") ))
```

Capitals with `tr`:

```bash
loud=$(tr 'a-z' 'A-Z' <<< "$text")
```

`$(...)` strips the trailing newline that `<<<` added, so `LOUD:` lines
up exactly.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
text=$1
words=$(( $(wc -w <<< "$text") ))
loud=$(tr 'a-z' 'A-Z' <<< "$text")
echo "words=$words"
echo "LOUD: $loud"
```

## Trying it by hand

```bash
./solution.sh "the website is down"
./solution.sh ""
```

## An alternative

`${text^^}` would uppercase without `tr`, and `read -a` can count words
without `wc`. Here the point is `<<<`, which you will reuse whenever a command
wants stdin and you hold the data in a variable.
