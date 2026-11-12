# Walkthrough: The Pipe Subshell Trap

## The plan
The counting logic in Theo's script is perfect. The only problem is where the loop runs. You will keep every line of logic and change only how the file reaches the loop.

## Step by step
1. Read the starter and find the line `cat "$1" | while read ...`. Every command in a pipeline runs in its own subshell, a child copy of your script. The loop increments `total` and `down` inside that copy. When the pipeline ends, the copy exits and takes its variables with it. Back in the main script both counters still hold 0.
2. Fix it by removing the pipe. Write `while read -r host state; do` as the first line of the loop and move the input to the end: `done < "$file"`. A redirect connects the file to the loop without creating a subshell, so the loop is part of your script.
3. Keep the argument check at the top and store the argument in `file=$1`.
4. The report line after `done` now sees the real numbers.

## Complete solution

```bash
#!/usr/bin/env bash
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh FLEETFILE" >&2
  exit 2
fi
file=$1

total=0
down=0
while read -r host state; do
  total=$(( total + 1 ))
  if [[ $state == down ]]; then
    down=$(( down + 1 ))
  fi
done < "$file"

echo "down: $down of $total"
```

## Trying it by hand
Make a fleet file with `printf 'a up\nb down\n' > f.txt` and run `bash solution.sh f.txt`. To see the trap, add `echo "inside: $down"` as the last line of the loop body in the pipe version: the number inside is right, the number after is wrong.

## An alternative
`shopt -s lastpipe` makes the last part of a pipeline run in the current shell, which also cures the problem (in scripts without job control). It is easy to forget when you read the script later, so the plain redirect is the safer habit. When the input comes from a command rather than a file, level 97 covers process substitution.
