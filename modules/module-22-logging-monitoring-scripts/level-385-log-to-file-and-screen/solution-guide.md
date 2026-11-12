# Walkthrough: Log to File and Screen

## The plan
Every event line has to reach two destinations: Ollie's screen and the log file
Noor will open tomorrow. `tee` is the tool that splits a stream in two. The
old log content must survive, so we append.

## Step by step
1. Check the arguments, and name them early so the loop reads well:

   ```bash
   [[ $# -ge 2 ]] || { echo "usage: solution.sh LOGFILE JOB" >&2; exit 2; }
   log=$1; job=$2
   ```

2. Fail before doing any work if the log cannot be written. `dirname` gives the
   folder portion of the path:

   ```bash
   [[ -d $(dirname "$log") ]] || { echo "cannot write to $log" >&2; exit 1; }
   ```

3. Loop over stdin and count. `tee -a` writes the line to stdout *and* appends
   it to the file:

   ```bash
   count=0
   while IFS= read -r line; do
     count=$((count + 1))
     printf '%s: %s\n' "$job" "$line" | tee -a "$log"
   done
   ```

4. Close the run with the summary line, through the same `tee -a`.

## Complete solution
See `answer.sh` after you pass. The shape is: checks, loop, closing line.

## Try it by hand
```
mkdir -p logs
printf 'one\ntwo\n' | ./solution.sh logs/sync.log demo
printf 'three\n'    | ./solution.sh logs/sync.log demo
cat logs/sync.log
```
The second run adds to the file rather than replacing it.

## Alternative
You could do `{ ...; } >> "$log"` for the file and a second `echo` for the
screen. That doubles every statement and the two copies can drift apart. With
`tee -a` there is one statement and one source of truth. Another approach is
`exec > >(tee -a "$log")` at the top of a script, which sends *everything* the
script prints through tee, handy once you are comfortable with process
substitution.
