# Walkthrough: Rate-Limited Calls

## The plan
Send requests one after the other, count them, and rest for a second after every pair, unless no work is left. A request that fails is still a request: it consumed quota and must not break the pacing.

## Steps
1. Usage check for an empty list.
2. Keep two counters: `sent` (requests made) and `remaining` (IDs not yet handled, starting at `$#`).
3. For each ID, call curl inside an `if`. Success prints the figure; failure prints `unavailable`. Either way:
   ```bash
   sent=$((sent + 1))
   remaining=$((remaining - 1))
   ```
4. The pacing rule is one line. `sent % 2 == 0` is true after every second request; `remaining > 0` prevents a sleep after the last one:
   ```bash
   if (( sent % 2 == 0 && remaining > 0 )); then
     sleep 1
   fi
   ```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -eq 0 ]]; then
  echo "usage: solution.sh CUSTOMER_ID..." >&2
  exit 2
fi

sent=0
remaining=$#

for id in "$@"; do
  if body=$(curl -sS --fail "https://billing.lanternfish.example/api/v1/customers/$id/usage" 2>/dev/null); then
    echo "$id: $body"
  else
    echo "$id: unavailable"
  fi

  sent=$((sent + 1))
  remaining=$((remaining - 1))

  if (( sent % 2 == 0 && remaining > 0 )); then
    sleep 1
  fi
done
```

## Try it by hand
```
./solution.sh c-204 c-310 c-415 c-512 c-620
cat .calls.log      # requests and recorded pauses, in order
```

## Alternative
Sleeping `0.5` after every request spreads the load evenly (also two per second) and needs no counter. It is simpler, but slower in practice for short lists, and fractional `sleep` is not guaranteed on every system. The pair-and-rest method uses only whole seconds.
