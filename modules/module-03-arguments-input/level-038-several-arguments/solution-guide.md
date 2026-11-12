# Walkthrough: Several Arguments

## The plan
Three inputs, one output line. Each input has a fixed position on the command
line, so each gets its own numbered variable. The only real work is matching
positions to meanings.

## Building it
Write down the contract first:

| Position | Variable | Meaning |
|---|---|---|
| 1 | `$1` | customer |
| 2 | `$2` | plan |
| 3 | `$3` | seats |

Naming the arguments at the top makes the last line easy to read:

```bash
customer=$1
plan=$2
seats=$3
echo "$customer -> $seats seats on the $plan plan"
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
customer=$1
plan=$2
seats=$3
echo "$customer -> $seats seats on the $plan plan"
```

## Try it by hand
```bash
./solution.sh "North Pier Dental" harbour 12
./solution.sh Dory starter 1
./solution.sh North Pier Dental harbour 12   # wrong: now $1=North $2=Pier $3=Dental
```
The last line is the classic failure. Quoting is what makes a multi-word value
a single argument.

## Alternative
You can skip the named variables and write `echo "$1 -> $3 seats on the $2 plan"`.
It works, but after a week nobody remembers that `$3` means seats, so for scripts
longer than one line the named version wins.
