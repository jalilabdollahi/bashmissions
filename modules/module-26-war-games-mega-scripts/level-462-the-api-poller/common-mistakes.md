# Common Mistakes

- **Alerting on every difference.** Wrong: comparing the new reading with the last reading and posting at once. One flaky response pages the whole town twice. Right: count consecutive confirmations against the *confirmed* status.
- **Not clearing the candidate on a good reading.** Wrong: leaving `down 1` in the state after an `ok`: the next `down` is then a "second" bad reading. Right: reset to `- 0` whenever the reading equals the confirmed status.
- **Losing alerts when the webhook is down.** Wrong: ignoring the failed `curl` and moving on. Right: append the body to `state/outbox` and flush it before polling next time.
- **Truncating the outbox while reading it.** Wrong: `while read ...; do ...; done < outbox > outbox`. Right: write survivors to `outbox.new` and `mv` it over.
- **Treating a curl failure as fatal.** Wrong: under `set -e`, `status=$(curl ...)` kills the poller on the first unreachable host. Right: `if ! body=$(curl ...); then reading=unreachable`.
- **Parsing JSON line by line.** Wrong: `grep status` misses a pretty-printed or reordered body. Right: flatten with `tr -d '\n'`, then one `sed` capture.
