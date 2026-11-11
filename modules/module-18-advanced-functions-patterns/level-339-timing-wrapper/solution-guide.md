# Walkthrough: Timing Wrapper

## The plan

Read the clock, run the command, read the clock again, report the difference.
It is the retry wrapper's skeleton (shift nothing, run `"$@"`, keep the status),
with a stopwatch where the loop was.

## Step by step

Bash 5 offers two time variables. `SECONDS` counts whole seconds since the
shell started: a command that takes 0.3 s would show 0. `EPOCHREALTIME` holds
the Unix time with microseconds, like `1700000000.123456`. Deleting the dot
turns it into an integer that arithmetic can subtract:

```bash
start=${EPOCHREALTIME/./}
```

Run the command so that a failure is recorded, not fatal. The report must
appear even when the command fails, so the status is kept for later:

```bash
rc=0
"$@" || rc=$?
end=${EPOCHREALTIME/./}
```

The difference is in microseconds; divide by 1000 for milliseconds. Splitting
into whole seconds and a three-digit remainder is the job of `printf`:

```bash
ms=$(( (end - start) / 1000 ))
printf 'timed: %s took %d.%03ds\n' "$*" $(( ms / 1000 )) $(( ms % 1000 )) >&2
return "$rc"
```

`%03d` pads with zeros, so 47 ms prints as `.047`, not `.47`. `"$*"` is the right
choice here: the report wants the words joined into one string, which is the
one place where `$*` is the better tool. The report goes to stderr so the
command's stdout stays clean for pipes.

The script finishes like the retry wrapper: `status=0; timed "$@" || status=$?;
exit "$status"`.

## Try it by hand

```
./solution.sh sleep 1
./solution.sh echo hi
./solution.sh false; echo "exit=$?"
```

## Alternative

The `time` keyword prints similar numbers, but its format is fixed by `TIMEFORMAT`
and it measures a pipeline, not a function you can post-process. And
`$(date +%s%N)` is not portable: `%N` does not exist on macOS.
