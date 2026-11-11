# Walkthrough: Add Two Numbers

## The plan

Arguments arrive as text. To add them we need Bash to treat that text as
numbers. The tool for that is arithmetic expansion: `$(( ... ))`. We name the
two inputs, add them inside the double parentheses, and print the result.

## Building it

First, give the positional parameters names a human can read:

```bash
anchovy_gb="$1"
barracuda_gb="$2"
```

Now the sum. Compare these two lines:

```bash
echo "$anchovy_gb$barracuda_gb"           # 7 and 5 give 75: just text side by side
echo "$(( anchovy_gb + barracuda_gb ))"   # 7 and 5 give 12: real addition
```

Inside `$(( ))` the shell is in "arithmetic mode": spaces are optional, and
variable names work without a leading `$`. The whole expression is replaced by
its result, so you can store it in a variable or print it right away.

Negative numbers work as you would hope, and so do huge ones: Bash uses 64-bit
signed integers, so even 7000000000 (which would overflow a 32-bit counter)
is no trouble.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

anchovy_gb="$1"
barracuda_gb="$2"

total=$(( anchovy_gb + barracuda_gb ))

echo "combined: $total GB"
```

## Try it by hand

```bash
./solution.sh 120 80
./solution.sh -15 40
./solution.sh 3000000000 4000000000
```

## An alternative

The old external command `expr 120 + 80` also adds, but it starts a new process
for every sum and has awkward quoting rules (`expr 6 \* 7`). `$(( ))` is built
into Bash, faster, and reads like normal maths. That is why it is the one to
reach for.
