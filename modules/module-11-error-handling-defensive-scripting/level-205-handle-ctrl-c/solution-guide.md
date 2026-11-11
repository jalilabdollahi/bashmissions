# Walkthrough: Handle Ctrl-C

## The plan
When you press Ctrl-C the terminal sends SIGINT to the running script. We
register a handler that records progress and exits with the status that callers
expect after an interruption, 130.

## Step by step
1. The loop keeps a running variable, `last`, which holds the number of the
   last batch that finished. That is the only fact the handler needs.

2. Write the handler as a function:

   ```bash
   on_interrupt() {
     echo "interrupted after batch $last"
     echo "$last" > import.state
     exit 130
   }
   ```

   The `exit 130` matters. A trap handler that returns normally lets the script
   *carry on* after the interrupted command, which is almost never what a
   Ctrl-C means.

3. Register it before the loop, so that no batch can run unprotected:

   ```bash
   trap on_interrupt INT
   ```

4. In the tests the loop sends the signal to itself (`kill -INT $$`, where `$$` is
   the script's own process id). That is the same as pressing Ctrl-C after the
   batch finishes, but deterministic. A script that finishes the loop never
   triggers the trap, so `import.state` is never created.

## Complete solution
```bash
#!/usr/bin/env bash
last=0
on_interrupt() {
  echo "interrupted after batch $last"
  echo "$last" > import.state
  exit 130
}
trap on_interrupt INT
for batch in 1 2 3 4 5; do
  last=$batch
  echo "batch $batch done"
  if [[ ${INTERRUPT_AFTER:-0} == "$batch" ]]; then kill -INT $$; fi
done
echo "import complete"
```

## Try it by hand
```bash
INTERRUPT_AFTER=2 ./solution.sh; echo "exit=$?"; cat import.state
./solution.sh   # and press Ctrl-C yourself if you add a sleep to the loop
```

## Alternative
Using the trap command inline, `trap 'echo bye; exit 130' INT`, is fine for
one-liners. A named function scales better once the handler grows.
