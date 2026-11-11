# Walkthrough: Loop over Files

## The plan
Let Bash turn `logs/*.log` into a list of real file names, then count the lines of each. Take care of two details: odd file names and an empty match.

## Step by step
1. Turn on `nullglob` with `shopt -s nullglob`. By default, a pattern that matches nothing stays as the literal text `logs/*.log`, and your loop would run once with a file that does not exist. With `nullglob` the pattern expands to zero words and the loop does not run.
2. Loop over the pattern: `for file in logs/*.log; do`. Bash expands and sorts the list before the first round. Names with spaces arrive as single items, because expansion results are never split again.
3. Count lines with `wc -l < "$file"`. Redirecting the file into `wc` keeps its name out of the output, leaving only the number. Wrap it in `$(( ... ))` to drop the padding spaces some systems add.
4. Strip the folder with `${file##*/}`, which removes the longest prefix ending in a slash.

## Complete solution

```bash
#!/usr/bin/env bash
shopt -s nullglob
for file in logs/*.log; do
  lines=$(( $(wc -l < "$file") ))
  echo "${file##*/}: $lines"
done
```

## Trying it by hand
`mkdir -p logs && printf 'a\nb\n' > logs/demo.log`, then run the script. Remove the line with `shopt` and delete the log: now you will see an error about `logs/*.log`. That is the problem `nullglob` solves.

## An alternative
`for file in $(ls logs/*.log)` looks similar but breaks on names with spaces and adds a process for nothing. Parsing `ls` output is a classic mistake; globs are always the right tool for files in a folder.
