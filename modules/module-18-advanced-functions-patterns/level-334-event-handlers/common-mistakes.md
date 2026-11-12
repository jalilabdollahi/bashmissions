# Common Mistakes

- **Overwriting instead of appending.** Wrong: `handlers[$event]=$fn` keeps only the last subscriber. Right: `handlers[$event]+=" $fn"`.
- **Registering names that are not functions.** Wrong: skipping the check, then `emit` fails later with "command not found" in the middle of a run. Right: `declare -F "$fn"` at registration time.
- **Forgetting `shift` in `emit`.** Wrong: handlers receive the event name as their first argument ("log: deploy harbour-bakery v2"). Right: `local event=$1; shift`, then forward `"$@"`.
- **Splitting the payload.** Wrong: `read -r line; "$fn" $rest` re-splits and globs the words, so `*` turns into file names. Right: parse into an array and pass `"${words[@]:2}"`.
- **Replaying history on late registration.** Subscribing after an event does not fire it; the registry only holds names, not past events. If you need replay, store the events too.
