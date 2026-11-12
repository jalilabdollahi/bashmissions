# Walkthrough: The Feature Flag System

## The plan
A feature flag separates *deploying* code from *releasing* it. The code ships switched off; a line in a config file turns it on for a few users, then more, and turning it off again needs no deploy. The tool has two halves. A **loader** that reads the file into memory and reports every problem with a file and line number. An **evaluator** that applies a fixed chain of rules to one flag and one user. The three commands (`check`, `list`, `validate`) just combine these two.

## Step by step

1. **Trim and skip.** Config files are written by humans: spaces around `=`, blank lines, comments. A small `trim` function with `${s#"${s%%[![:space:]]*}"}` strips both ends without `sed`.

2. **Parse a line.** Split at the first `=` with `${line%%=*}` (name) and `${line#*=}` (the rest). Validate the name with a regex, then `read -r state rest` peels off the state word and leaves the options. Loop over the options with a `case` on the key. Each problem is reported through one `problem` function that prints `FILE:LINE: message` and increments a counter. Only the first problem per line is reported, so use `continue` or `break` after one.

3. **Store.** Associative arrays hold the state, rollout and the three lists. The lists are stored wrapped in commas, `,ollie,noor,`, which turns membership into a glob match: `[[ $allow == *",ollie,"* ]]`. Wrapping avoids the classic bug where `ann` matches inside `joanne`. A plain array remembers the file order for `list`.

4. **Decide.** The order of the rules is the design. The kill switch is first so an operator can always shut a feature down, even for allow-listed people. Deny comes before allow. The environment restriction comes before allow too. Only then is the rollout consulted.

5. **The bucket.** `cksum` of `FLAG:USER` modulo 100 gives every user a fixed position from 0 to 99 for each flag. Raising the rollout from 20 to 30 therefore keeps the first 20% on and adds 10% more, instead of reshuffling everybody. Including the flag name in the hash means a user is not always in the "lucky" 5% of every feature. A user is on when `bucket < rollout`, so `rollout=0` is truly nobody and `100` everybody.

6. **Exit codes as an API.** `check` exits 0 for on and 1 for off, so a shell script can write `if solution.sh flags check new-checkout "$user"; then ...`. A broken file exits 3 so it cannot be confused with "off".

## Complete solution
The core of the evaluator:
```bash
if   [[ ${fstate[$flag]} == off ]]; then decision=off reason="kill switch"
elif [[ ${fdeny[$flag]} == *",$user,"* ]]; then decision=off reason=denied
...
else
  read -r sum _ < <(printf '%s' "$flag:$user" | cksum)
  bucket=$((sum % 100))
fi
```

## Try it by hand
```bash
./solution.sh fixtures/flags.conf validate
./solution.sh fixtures/flags.conf check new-checkout mara
./solution.sh fixtures/flags.conf list ollie dev
```

## Alternative
Compare the hash with `<=` or store the rollout as a fraction. The strict `<` against 0..99 is easiest to explain: percent N turns on exactly N of the 100 buckets.
