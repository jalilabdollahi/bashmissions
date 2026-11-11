# Walkthrough: Trace to a File

## The plan
By default xtrace writes to stderr, which is shared with real warnings and with
whatever reads stderr (here, an e-mail). We want the trace in a file of its own.
Bash has a variable for this: `BASH_XTRACEFD`, the number of the file descriptor
that receives the trace.

## Step by step
1. A descriptor must exist before Bash can write to it. `exec` with only a
   redirection opens it for the rest of the script:

   ```bash
   exec 3>trace.log
   ```

   Descriptor 3 is now connected to `trace.log`; the `>` truncates the file, so
   each run starts with a fresh trace.

2. Point xtrace at it:

   ```bash
   BASH_XTRACEFD=3
   ```

3. Switch tracing on, run the two commands, switch it off, as in the starter.
   Nothing about the trace appears on the terminal any more.

4. Check the three places:

   ```
   $ ./solution.sh eel 4
   site eel has 5 pages
   warning: eel is slow
   $ cat trace.log
   + count=5
   + echo 'site eel has 5 pages'
   + set +x
   ```

   Stdout has the report, stderr has the warning, the file has the trace.

## Complete solution
```bash
#!/usr/bin/env bash
exec 3>trace.log
BASH_XTRACEFD=3
set -x
count=$(( $2 + 1 ))
echo "site $1 has $count pages"
set +x
echo "warning: $1 is slow" >&2
```

## Try it by hand
```bash
./solution.sh dory 9 2>/dev/null
cat trace.log
```

## Alternative
Run the whole script with `bash -x solution.sh eel 4 2>trace.log`. That also
puts the trace in a file, but it takes everything on stderr with it, warnings
included. `BASH_XTRACEFD` separates the two.
