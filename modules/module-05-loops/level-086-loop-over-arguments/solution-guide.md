# Walkthrough: Loop over Arguments

## The plan
Make sure the reports folder exists, then visit every argument and do two things with it: write a file and announce it. The only subtlety is that names can contain spaces.

## Step by step
1. Reject an empty call: `[[ $# -eq 0 ]]` is true when there are no arguments. Print the usage line to stderr and `exit 2`.
2. `mkdir -p reports` creates the folder and is silent if it is already there. Do it once, before the loop.
3. Loop with `for name in "$@"; do`. The special form `"$@"` expands to each argument as a separate word, exactly as the caller typed them. `Gull & Anchor Pub` stays one item.
4. Use the name inside double quotes every time: `echo "report for $name" > "reports/$name.txt"`. The quotes after `>` matter too, otherwise Bash would split the file name.
5. Print the confirmation line.

## Complete solution

```bash
#!/usr/bin/env bash
if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh NAME..." >&2
  exit 2
fi

mkdir -p reports
for name in "$@"; do
  echo "report for $name" > "reports/$name.txt"
  echo "created reports/$name.txt"
done
```

## Trying it by hand
`bash solution.sh "Harbour Bakery" Tidewater`, then `ls reports`. Next, edit the script to use `for name in $@` without quotes and run it again: you will see files called `Harbour.txt` and `Bakery.txt`.

## An alternative
`for name; do ... done` (no `in` part) loops over the arguments by default. It is valid and short, but spelling out `in "$@"` makes the intention obvious to the next reader.
