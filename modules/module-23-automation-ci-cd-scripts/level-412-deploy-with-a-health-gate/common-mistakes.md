# Common Mistakes

- **Polling forever.** Wrong: `until curl -s "$url"; do sleep 2; done` never ends if the release is broken. Right: a counted loop and `gave up after N attempts`.
- **Forgetting `-f`.** Wrong: `curl -s "$url"` exits 0 on a 503 page, so the gate opens on a dead service. Right: `curl -fs`, so HTTP errors become a failing status.
- **No request timeout.** Wrong: a hung endpoint blocks one attempt for minutes. Right: `--max-time 2`.
- **Sleeping after the last attempt.** Wrong: `sleep 2` at the end of every round delays the failure by a useless pause. Right: `(( attempt < max )) && sleep 2`.
- **Off-by-one in the counter.** Wrong: `attempt < max` in the loop runs one try too few. Right: start at 1 and loop while `attempt <= max`.
