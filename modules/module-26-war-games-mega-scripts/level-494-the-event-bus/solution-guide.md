# Walkthrough: The Event Bus

## The plan
Publish/subscribe decouples the people who have news from the people who want it. Publishers write to a *topic* and know nothing about listeners; subscribers declare a *pattern* and a *handler*. In a real system a broker process does the work; here the broker is a directory, and the dispatcher is a script you run.

The design that makes this robust is the **log plus cursors** model, the same one used by Kafka and by `tail -f`-style tools. Messages are appended as numbered files and never modified. Each subscriber has a cursor: the number of the last message it has dealt with. Delivering means walking forward from the cursor. That single idea gives you independence (each subscriber moves at its own pace), replay (reset a cursor to go back), ordering (messages arrive in number order) and late joining (a new subscriber starts at the end of the log).

## Step by step

1. **Validate names** with regexes before any file is touched. Handlers are restricted to a single command word, because the dispatcher will *run* them: allowing spaces or shell characters would turn a subscription into a command injection.

2. **Numbering.** `last_seq` scans the spool for the highest number (forcing base 10 with `10#`, since `000008` would otherwise be read as an octal error). `publish` takes the next number but must not trust that nobody else did the same moments ago. Under `noclobber` (`set -C`, inside a subshell so the setting does not leak) the redirection `>` refuses to overwrite: if two publishers pick the same number, only one succeeds and the other moves on. That is an atomic claim without a lock.

3. **Subscribe at the end of the log.** The cursor starts at the current last number, so a new subscriber is not flooded with history.

4. **Dispatch.** For each subscriber, in name order, loop over messages after the cursor. A topic that does not match the pattern is skipped, and the cursor moves on so it is not looked at again. Matching uses a glob: `[[ $topic == $pattern ]]` with the pattern *unquoted*. On success the cursor advances immediately (so a crash mid-run never re-delivers what was done) and any retry record is dropped.

5. **Failure handling.** One attempt per message per run. The count of failed attempts is stored with the message number (`SEQ COUNT`), so a different message starts from zero. Below `MAX_TRIES` the subscriber *stops* for this run: its later messages must not overtake the failed one, because order matters (a "deploy finished" must not arrive before "deploy started"). At the limit the message is copied to `dead/` for a human, the cursor moves past it, and the subscriber continues. Other subscribers are never affected by one subscriber's failure.

6. **Report.** The summary counts deliveries, failures and dead letters, and the exit status tells a scheduler whether anything needs attention. `status` computes pending messages from cursor and pattern.

## Complete solution
The atomic claim:
```bash
n=$(( $(last_seq) + 1 ))
until ( set -C; printf '%s\n%s\n' "$topic" "$text" > "$spool/$(printf '%06d' "$n")" ) 2>/dev/null; do
  n=$((n + 1))
done
```

## Try it by hand
```bash
mkdir bus
./solution.sh bus subscribe 'deploy.*' board status-board
./solution.sh bus publish deploy.failed v1.5.0 health check failed
./solution.sh bus dispatch
./solution.sh bus status
```
(`status-board` is a stub that records its call in `.calls.log`.)

## Alternative
Named pipes (`mkfifo`) give instant delivery, but a pipe has no memory: a subscriber that is not listening when you publish misses the message, and a blocked reader blocks the writer. The spool directory is slower and survives crashes, restarts and slow consumers.
