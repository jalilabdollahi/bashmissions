# Walkthrough: Meaningful Exit Codes

## The plan
The script is a ladder of checks, cheapest first. Each rung either passes or
ends the script with its own message and its own number. By the time the last
line runs, everything the success message promises has been verified.

## The codes
Zero means success by convention and 1 is the generic "something broke", so we
start the specific ones at 2 (also the conventional "misused command"):

| code | meaning |
|---|---|
| 2 | usage: no config argument |
| 3 | config file missing or unreadable |
| 4 | config exists but has no usable `port=` |
| 5 | the service did not answer the probe |

## Step by step
1. Argument check. `${1:-}` is safe even under `set -u`:

   ```bash
   config=${1:-}
   if [[ -z $config ]]; then echo "usage: solution.sh CONFIG" >&2; exit 2; fi
   ```

2. File check with `[[ ! -r $config ]]`, exit 3.

3. Extract the first port line and make sure it is a number:

   ```bash
   port=$(grep '^port=' "$config" | head -n 1 | cut -d= -f2 || true)
   [[ $port =~ ^[0-9]+$ ]] || { echo "config has no valid port: $config" >&2; exit 4; }
   ```

   An empty `$port` (no line at all) fails the same test as `http`.

4. Probe: `if ! probe "$port" 2>/dev/null; then ... exit 5; fi`, then the success line.

## Complete solution
See `answer.sh`, which also names the four codes with `readonly` variables.

## Try it by hand
```bash
echo port=8080 > dory.conf
./solution.sh dory.conf; echo "exit=$?"
FAKE_PROBE_DOWN=1 ./solution.sh dory.conf; echo "exit=$?"
./solution.sh; echo "exit=$?"
```

## Alternative
One generic `exit 1` plus a message is easier to write, but a machine reading
the status cannot tell the cases apart. The numbers cost nothing and let cron,
CI and monitoring route each problem by itself.
