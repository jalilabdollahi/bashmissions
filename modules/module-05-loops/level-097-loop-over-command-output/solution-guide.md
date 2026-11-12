# Walkthrough: Loop over Command Output

## The plan
Let `fleet-disk` produce the lines, read them in a loop in your own shell, and update three variables as you go: the name and value of the fullest disk, and the count of disks above 80 percent.

## Step by step
1. Initialise the state: `fullest_host=none`, `fullest_pct=-1`, `over=0`. Starting the maximum at -1 means the first real value (even 0) beats it, and if there are no lines, the name stays `none`.
2. Loop with `while read -r host pct; do`. The two variable names split each line into the server and the number.
3. Track the maximum: `if (( pct > fullest_pct ))`. Because the test is a strict "greater than", a tie keeps the earlier host, as required.
4. Count the dangerous ones: `if (( pct > 80 ))`, then increment `over`. Exactly 80 is not counted.
5. Connect the command at the end of the loop with `done < <(fleet-disk)`. `<(...)` runs the command and presents its output as a readable file; the plain `<` in front redirects that into the loop. The loop is not in a pipeline, so no subshell is created.
6. Report. The "no servers" case needs different text for line 1: check `fullest_host`.

## Complete solution

```bash
#!/usr/bin/env bash
fullest_host=none
fullest_pct=-1
over=0
while read -r host pct; do
  if (( pct > fullest_pct )); then
    fullest_host=$host
    fullest_pct=$pct
  fi
  if (( pct > 80 )); then
    over=$(( over + 1 ))
  fi
done < <(fleet-disk)

if [[ $fullest_host == none ]]; then
  echo "fullest: none"
else
  echo "fullest: $fullest_host (${fullest_pct}%)"
fi
echo "over 80%: $over"
```

## Trying it by hand
Create a `disk.txt` such as `printf 'a 10\nb 90\n' > disk.txt`; the practice workspace provides the `fleet-disk` helper that prints it. Then run `bash solution.sh`.

## An alternative
`fleet-disk | while read ...` looks simpler but loses the variables (level 94). You could also save the output first (`report=$(fleet-disk)`) and loop over `<<< "$report"`; that is also correct, with a temporary copy of the data in memory.
