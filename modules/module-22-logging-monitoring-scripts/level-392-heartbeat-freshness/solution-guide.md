# Walkthrough: Heartbeat Freshness

## The plan
A hung job leaves no error, only silence. So each job touches a heartbeat file
as it finishes a cycle, and the checker asks how recently that happened. Rather
than calculating ages from the clock, compare each heartbeat with a stamp file
whose modification time is set (by cron) to the oldest acceptable moment. The
shell can compare two files' modification times directly.

## Step by step
1. Check the arguments, then make sure the stamp exists. Without a reference
   point every answer would be a guess, so this is an error, not a verdict:

   ```bash
   [[ -e $stamp ]] || { echo "no stamp file: $stamp" >&2; exit 2; }
   ```

2. Take the stamp off the argument list with `shift` so `"$@"` holds only
   heartbeats. Loop with `for beat in "$@"`, which keeps names with spaces whole.

3. Derive the display name: `basename "$beat" .beat` strips the directory and
   the suffix in one go.

4. Three cases, in this order, because a missing file would otherwise look like
   an error in the time comparison:

   ```bash
   if   [[ ! -e $beat ]];       then echo "MISSING $name"
   elif [[ $beat -ot $stamp ]]; then echo "STALE $name"
   else                              echo "fresh $name"
   fi
   ```

   `-ot` is true only when the beat is *strictly* older, so an equal time
   counts as fresh, as the spec asks.

5. Remember a failure in a variable and `exit "$bad"` after the loop, so every
   heartbeat is reported before the script ends.

## Try it by hand
```
touch -t 202603011000 stamp
touch -t 202603010900 old.beat
touch -t 202603011005 new.beat
./solution.sh stamp old.beat new.beat gone.beat; echo $?
```

## Alternative
`find beats -name '*.beat' -mmin +5` lists beats older than five minutes using
the real clock. It is handy interactively, but the stamp-file comparison is
testable (you decide what "now" is) and identical on Linux and macOS.
