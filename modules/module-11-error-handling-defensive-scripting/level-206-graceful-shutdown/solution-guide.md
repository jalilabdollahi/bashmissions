# Walkthrough: Graceful Shutdown

## The plan
A graceful shutdown has three parts: notice the request, finish the current unit
of work, and leave things in a state the next run can pick up. The trap handles
only the first part.

## Step by step
1. Create a flag, and register a handler that raises it:

   ```bash
   stopping=0
   request_stop() { stopping=1; }
   trap request_stop TERM
   ```

   The handler does not call `exit`. In the test the script signals itself while
   a job is running; Bash runs the handler right after that command and then
   resumes the job, which prints "finished ..." as normal.

2. Check the flag at a safe point: the start of an iteration, where no job is
   half done.

   ```bash
   if (( stopping )); then break; fi
   ```

3. After the loop, report. `done_count` jobs finished, so the untouched ones
   are the array slice from index `done_count` to the end:

   ```bash
   left=$(( ${#jobs[@]} - done_count ))
   printf '%s\n' "${jobs[@]:done_count}" > queue.left
   ```

   `queue.left` is created even if the slice is empty, which is what the last
   test checks.

4. A clean shutdown is a success, so the worker leaves with `exit 0`.

## Complete solution
See `answer.sh`: it is the starter plus the flag, the trap, the `break` and the
final `if (( stopping ))` block.

## Try it by hand
```bash
printf 'a\nb\nc\n' > queue.txt
TERM_DURING=b ./solution.sh; cat queue.left
```

## Alternative
Exit directly in the handler. That is simpler, but the job running at that
moment is abandoned half-done. For short, restartable jobs this is fine; for
anything that writes files or talks to a customer it is not.
