# Walkthrough: Top Talkers

## The plan
Three small stages in a pipeline, each doing what it is best at: awk totals per
client, sort ranks, a second awk numbers and trims. The data between stages is
plain lines, so each stage can be run and checked on its own.

## Step by step
1. **Argument.** `limit=${2:-3}` supplies the default. A regex check
   `^[1-9][0-9]*$` rejects `0`, `-1`, `abc` and empty, with the usage message on
   stderr and exit status 2.

2. **Totals.** In the first awk, skip lines with fewer than three fields.
   `requests[$2]++` counts every line; `bytes[$2] += $3` adds only when `$3` is
   digits. A `-` must not add (it would count as 0 anyway), but the client has
   to exist in `bytes`, so it is initialised to 0 when unseen. `END` prints
   `client requests bytes`, using `%.0f` so large sums stay plain integers.

3. **Rank.** `sort -k3,3nr -k1,1`: field 3 numerically, highest first; clients
   with the same total fall back to field 1 in character order, so the output
   is the same on every machine.

4. **Number and cut.** The last awk prints only lines with `NR <= limit`,
   formatted with the rank (`NR`). It reads all of its input, so sort never
   sees a closed pipe, which matters under `set -o pipefail`.

## Complete solution
See `answer.sh`; the pipeline is:
```bash
awk '...totals...' "$1" | sort -k3,3nr -k1,1 | awk -v limit="$limit" 'NR <= limit { printf ... }'
```

## Try it by hand
```bash
awk '{ n[$2]++; s[$2] += $3 } END { for (k in n) print k, n[k], s[k] }' fw.log | sort -k3,3nr
./solution.sh fw.log 2
```

## Alternative
`awk ... | sort ... | head -n "$limit"` is shorter. With `set -o pipefail` it can
fail intermittently: when `head` exits early on a large input, `sort` receives
SIGPIPE and the pipeline reports an error status. Putting the limit in awk
avoids the question.
