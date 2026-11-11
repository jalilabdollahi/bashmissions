# Walkthrough: Trace Only the Suspect

## The plan
The report script is short, but imagine it with a hundred lines. Tracing
everything buries the clue. Only the two arithmetic lines can explain "0
minutes", so we surround exactly those with a trace switch.

## Step by step
1. Keep the first `echo` where it is, outside the block.

2. Before the arithmetic, switch tracing on:

   ```bash
   set -x
   ```

3. After the arithmetic, switch it off:

   ```bash
   set +x
   ```

4. Run `./solution.sh 1000 1090`. Stderr shows:

   ```
   + elapsed=90
   + minutes=1
   + set +x
   ```

   The `+ set +x` line is not a mistake: tracing is still on while Bash executes
   the command that turns it off, so that command gets printed once.

5. Notice what the trace gave away. With `./solution.sh 50 59` you see
   `+ minutes=0`: integer division by 60 throws away anything under a minute,
   which is why short jobs read "0m".

## Complete solution
```bash
#!/usr/bin/env bash
echo "report for backup job"
set -x
elapsed=$(( $2 - $1 ))
minutes=$(( elapsed / 60 ))
set +x
echo "backup took ${minutes}m"
```

## Try it by hand
```bash
./solution.sh 1000 1090
./solution.sh 1000 1090 2>/dev/null     # trace hidden, output only
```

## Alternative
Trace the whole script (`bash -x solution.sh 1000 1090 2>trace.txt`) and search
the trace afterwards with `grep elapsed trace.txt`. That needs no edit to the
script, but on a long script the file is huge and the interesting part is
easy to miss; a scoped `set -x` / `set +x` keeps the output small.
