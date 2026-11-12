# Walkthrough: The Service Health Dashboard

## The plan
A dashboard has two jobs that should never be tangled together: *gathering* facts and
*presenting* them. Gathering is slow and unpredictable (network timeouts), so it runs in parallel.
Presenting must be calm and repeatable, so it happens afterwards, from files, in the order of the
config. Each check type is a tiny function that answers in the same shape (`STATE|detail`), which
is what lets the printing code ignore what kind of check produced the row.

## Step by step
1. **Validate first.** Read the config into five parallel arrays. Any malformed line stops the
   script with exit 3 *before* anything is checked: it would be a poor dashboard that shows half a
   board because line 14 had a typo. Line numbers count comments too, so the message points at
   the right line of the file.

2. **Check functions.** `check_http` uses `curl -w '%{http_code}'` and turns a curl failure into
   `000` with `|| code=000` (this also keeps `set -e` quiet). `check_tcp` splits `HOST:PORT` with
   `${1%:*}` and `${1##*:}`. `check_file` uses `find FILE -mmin -N`, "was it modified in the last N
   minutes". `check_disk` takes the Capacity column from the POSIX `df -P` output; `-P` matters because
   without it long device names wrap the line and break `awk` field numbers.

3. **Parallel execution.** One background subshell per service, each redirecting its own
   output to `$work/$i`, followed by a single `wait`. Using the array index as the file name is
   what gives deterministic ordering: you read `0, 1, 2 ...` no matter who finished first.
   `mktemp -d` and a trap give the scratch space and its cleanup.

4. **Grouping.** An associative array `seen` plus an ordered `groups` array gives "order of first
   appearance". Counting the UP rows of each group first lets the header show `[U/N up]`, even
   when `--problems-only` hides the healthy rows.

5. **Colour.** Pad the state word to eight characters *before* wrapping it in escape codes,
   otherwise the invisible bytes confuse `printf`'s width calculation and the columns slip. Colour
   is opt-in because the output often goes to files and pagers.

6. **Overall state.** A critical service (name ending `!`) that is DOWN makes the board DOWN; any
   other problem makes it DEGRADED. This is the difference between "a webcam is stale" and
   "the ferry site is dead". The exit status mirrors it.

## Try it by hand
```
./solution.sh services.conf; echo "exit=$?"
./solution.sh --color --problems-only services.conf
```

## Alternative
A sequential loop is shorter and fine for five checks. With forty and a 3-second timeout per dead
host it takes two minutes, which is exactly the delay the board exists to remove. The cost of
parallelism here is five lines and one directory.
