# Walkthrough: Head and Tail Windows

## The plan
To print lines FIRST to LAST we can do it in two moves: keep the first LAST
lines of the file, then discard the first FIRST-1 of those. The result is
exactly the window.

## Step by step
1. `head -n N` prints the first N lines. With `head -n "$last" "$file"` we have
   lines 1..LAST. If the file is shorter than LAST, `head` just prints all of it,
   which is the behaviour the task asks for.

2. `tail -n +N` is the unusual one. With a plus sign it means "start at line N"
   rather than "the last N lines". So `tail -n +"$first"` prints from line FIRST
   to the end of its input.

3. Pipe the first into the second:

   ```bash
   head -n "$last" "$file" | tail -n +"$first"
   ```

   For `3 5`, head produces lines 1 to 5 and tail drops lines 1 and 2, leaving
   3, 4, 5. For a FIRST past the end, tail has nothing left to print, so the
   output is empty.

4. Copy the arguments into named variables at the top so the pipeline reads
   like the sentence it implements.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
file=$1 first=$2 last=$3
head -n "$last" "$file" | tail -n +"$first"
```

## Try it by hand
```bash
seq 1 10 > n.txt
./solution.sh n.txt 3 5          # 3 4 5
tail -n 2 n.txt                  # 9 10, the last two
tail -n +9 n.txt                 # 9 10, from line 9 on
head -n 3 n.txt                  # 1 2 3
```

## Alternative
`sed -n "${first},${last}p" "$file"` prints the same window in one command, and
a later level covers sed ranges. The head and tail pair is worth knowing
because it works on any Unix and reads naturally: first N lines, then from
line M.
