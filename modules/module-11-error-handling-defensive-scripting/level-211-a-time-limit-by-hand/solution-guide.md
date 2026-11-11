# Walkthrough: A Time Limit by Hand

## The plan
A foreground command blocks the script until it ends, so a hung command cannot be
interrupted by the script itself. Put the command in the background and the script
stays in charge: it sleeps for the budget, checks whether the job is alive, and
kills it if so.

## Step by step
1. Start the scan in the background and keep its process ID:

   ```bash
   lanternscan &
   pid=$!
   ```
   `$!` always holds the PID of the most recent background job.

2. Spend the budget: `sleep "$limit"`. (Fractional seconds are fine on both
   macOS and Linux.)

3. Ask whether the job still exists. `kill -0` sends no signal at all; it only
   reports through its exit status whether the PID is alive:

   ```bash
   if kill -0 "$pid" 2>/dev/null; then
   ```

4. It overstayed. Stop it with a plain `kill` (that sends TERM), `wait` for it so
   the shell tidies up, tell stderr, and leave with 124, the code the real
   `timeout` command uses:

   ```bash
   kill "$pid"; wait "$pid" 2>/dev/null
   echo "scan timed out after $limit seconds" >&2
   exit 124
   ```

5. It already finished. `wait "$pid"` returns the job's own exit status, which we
   pass on if it is not zero.

## Try it by hand
```bash
SCAN_SECONDS=5 ./solution.sh 0.5; echo "exit=$?"   # 124
SCAN_SECONDS=0.1 ./solution.sh 0.5                 # scan complete
```

## Alternative
A polling loop (check every 0.1 s, leave the moment the job ends) returns sooner
for fast scans, at the price of more code. The sleep-then-check version is the
smallest correct one, which is why it is the one to learn first.
