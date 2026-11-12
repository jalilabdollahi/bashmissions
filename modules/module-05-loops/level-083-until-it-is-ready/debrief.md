# Debrief: until It Is Ready

`while` repeats while something is true; `until` repeats while something is false. Both are driven by exit status, not by values. Any command can be the condition: a test, an arithmetic check, a program like `grep`, `ping` or your own probe.

## How it works
Bash runs the condition command, reads its exit status, and decides. For `until`, status 0 means "done, leave the loop", anything else means "run the body once more". Output of the condition command itself still appears on the screen unless you silence it with `> /dev/null` or `grep -q`.

The counting pattern from this level, start at 1 and increment only inside the body, is worth remembering. It guarantees the counter equals the number of the check that finished the loop.

An until loop with no pause and no limit is dangerous in production: if the thing never becomes ready, the script spins forever. Real scripts add a `sleep` between checks and a maximum number of attempts. You will build the second part in level 96.

## In real work
Waiting for a port to open, a deploy to finish, a file to appear, a DNS record to propagate. Every "wait for it" in an automation script is an `until`.

## Going further
Next, the opposite need: stop a loop early from inside, with `break`.
