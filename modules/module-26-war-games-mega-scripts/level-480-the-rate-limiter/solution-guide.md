# Walkthrough: The Rate Limiter

## The plan
A token bucket is the friendliest rate limiter there is. Every client owns a bucket with a capacity. Time drips tokens into it at a fixed pace, each request takes some out, and an empty bucket means "wait". Bursts are allowed (a full bucket can serve `capacity` requests at once) but the long-run average cannot exceed the refill rate. The only state per client is two integers: the tokens and the time of the last top-up.

The one design choice that makes this mission testable is that the script never asks what time it is. Every request line carries its own timestamp, so the same traffic file always gives the same answers.

## Step by step

1. **Parse the rules.** `read -r client c s _` splits each rule line; comments and blanks are skipped; `*` goes into two plain variables as the default. Per-client rules go into `cap[]` and `spt[]`.

2. **Load the saved buckets** from STATE into `tokens[]` and `last[]`. A missing file just means no buckets yet.

3. **Refill.** The elegant part. With integers only, whole tokens earned are `elapsed / spt`. If you then set `last=ts` you silently erase the leftover fraction: ask every 9 seconds against a 10 second refill and you would never earn a single token. So `last` advances by `added * spt` only. The exception is a full bucket, which has no progress worth keeping, so there `last=ts`. Forgetting that exception lets an idle client "bank" time while full and then burst beyond its capacity.

4. **Decide.** First the impossible case (`cost > capacity`), then allow (subtract, print what is left), then deny. The retry hint is the time at which the missing tokens will exist: `last + missing*spt - ts`. Because `last` was advanced only by whole periods, this stays correct for partial progress.

5. **Validate each line** before using it: field count, digits, cost at least 1, timestamps never moving backwards. Bad lines are reported with their physical line number, skipped, and make the final exit status 1, but never stop the replay. A limiter that crashes on one damaged log line is worse than no limiter.

6. **Persist.** Print the summary, then write the buckets sorted so the file is stable between runs and easy to diff.

## Complete solution
```bash
refill() {
  local c=$1 ts=$2 added
  if (( ts > last[$c] )); then
    added=$(( (ts - last[$c]) / spt[$c] ))
    tokens[$c]=$(( tokens[$c] + added ))
    last[$c]=$(( last[$c] + added * spt[$c] ))
  fi
  if (( tokens[$c] >= cap[$c] )); then tokens[$c]=${cap[$c]}; last[$c]=$ts; fi
}
```
The rest is the loop that calls it; see `answer.sh` after you pass.

## Try it by hand
```bash
printf 'bakery 3 10\n' > limits.conf
printf '100 bakery\n100 bakery\n100 bakery\n100 bakery\n' | ./solution.sh limits.conf state.db
cat state.db
```
Run it again with timestamps 105 and 112 and watch the remainder carry over.

## Alternative
A "sliding window log" stores every request time and counts those in the last N seconds. It is exact but needs memory proportional to traffic, while the bucket needs two integers per client. A "fixed window" counter is simpler still but lets a client send double the limit around a window boundary. The bucket is the usual compromise.
