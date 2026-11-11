# Debrief: Doubling Delays

Exponential backoff is a loop in which one variable feeds itself: this round's output is the next round's input. Doubling is the simplest recurrence, and it shows how a few lines can create a quickly growing sequence.

## How it works
The schedule 1, 2, 4, 8, 16 grows so fast that without a cap it passes any sensible limit after a few attempts: attempt 20 would be about six days. The cap turns the curve into a ramp that levels off. Placing the cap check inside the loop, before the value is used, guarantees every printed delay respects it, whatever overshot in the previous round.

Computing the schedule without sleeping is a useful habit: you can test the logic instantly, review it with a colleague, and only then wire it to real waits. Separating "decide what to do" from "do it" is how real scripts stay testable.

Why double the wait at all? A struggling service needs breathing room. If all clients retry once per second, the load stays constant at the moment the service is weakest. Growing delays spread the retries out, and random jitter (extra small random wait) avoids everyone returning at the same instant.

## In real work
Retrying API calls, polling a slow job, reconnecting to a database, rate-limited downloads.

## Going further
Next, loops that consume the output of another command, without falling into the pipe trap.
