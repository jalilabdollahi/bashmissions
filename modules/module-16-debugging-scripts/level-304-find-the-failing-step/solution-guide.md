# Walkthrough: Find the Failing Step

## The plan
`try-steps K` is a yes/no question: "is the broken step within the first K?" The
answer is monotonic: once K reaches the broken position, every larger K fails
too. That is exactly the situation binary search needs. Instead of up to N
rehearsals we need about log2(N).

## Step by step
1. Load the names with `mapfile -t steps < "$1"` and take `n=${#steps[@]}`.

2. Ask about the whole list first:

   ```bash
   if try-steps "$n" > /dev/null 2>&1; then
     echo "all $n steps pass"
     exit 0
   fi
   ```

   The `if` turns a failing exit status into an answer, so `set -e` does not
   fire, and the redirections drop the stub's chatter so nothing reaches stdout
   or stderr.

3. Now we know the culprit exists. Keep an interval `lo..hi` of positions that
   might hold it, starting with `1..n`, and cut it in half until a single
   position is left:

   ```bash
   lo=1; hi=$n
   while (( lo < hi )); do
     mid=$(( (lo + hi) / 2 ))
     if try-steps "$mid" > /dev/null 2>&1; then
       lo=$(( mid + 1 ))
     else
       hi=$mid
     fi
   done
   ```

   If the first `mid` steps pass, the broken step is after `mid`, so `lo`
   moves past it. If they fail, the culprit is at `mid` or earlier, so `hi`
   becomes `mid` (not `mid - 1`: `mid` itself may be the culprit).

4. Report. Positions count from 1, array indexes from 0, so the name is
   `${steps[lo - 1]}`:

   ```bash
   echo "first failing step: $lo ${steps[lo - 1]}"
   ```

## Complete solution
Steps 1 to 4 in order make up the script (with `set -euo pipefail` on top).

## Try it by hand
```bash
printf 'a\nb\nc\nd\ne\nf\n' > steps.txt
BAD_AT=4 ./solution.sh steps.txt
cat .calls.log        # the rehearsals you ran
```

## Alternative
A linear scan (`for k in 1 2 3 ...; try-steps $k`) is simpler and gives the same
answer, but needs up to N rehearsals. With ten minutes each, 20 steps is the
difference between an afternoon and under an hour.
