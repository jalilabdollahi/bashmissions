# Walkthrough: Trace with set -x

## The plan
The three commands already do the job. What is missing is visibility. One
option, `set -x`, makes Bash print each command to stderr right before it runs.

## Step by step
1. Start from the starter. Run it and notice that it only prints `ready: ...`.
   You cannot tell which folder was really created.

2. Add the switch before the first command:

   ```bash
   set -x
   ```

3. Run it and read the trace. Each line starts with `+ ` and shows the command
   *after* Bash expanded it:

   ```
   + dest=backups/harbour
   + mkdir -p backups/harbour
   + echo 'ready: backups/harbour'
   ready: backups/harbour
   ```

   The trace goes to stderr, the `ready:` line to stdout. They are separate
   streams, so `./solution.sh x > out.txt` keeps the trace on screen and only
   the real output in the file.

4. Try a name with a space and watch how the quoting shows up:

   ```
   + dest='backups/Tidewater Books'
   ```

   The single quotes in the trace are Bash telling you the value is one word.

## Complete solution
```bash
#!/usr/bin/env bash
set -x
dest=backups/$1
mkdir -p "$dest"
echo "ready: $dest"
```

## Try it by hand
```bash
./solution.sh harbour
./solution.sh "Tidewater Books" 2>trace.txt
cat trace.txt
```

## Alternative
You can trace a script without editing it: `bash -x solution.sh harbour`. That is
handy for a script you do not own. Putting `set -x` inside the file is better
when the trace should always be available to whoever runs it.
