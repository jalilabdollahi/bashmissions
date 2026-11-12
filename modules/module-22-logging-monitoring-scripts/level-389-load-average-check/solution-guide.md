# Walkthrough: Load Average Check

## The plan
`uptime` ends with `load average: 0.52, 0.58, 0.59`. Capture the line, keep only
what follows the label, split it into three variables, and compare. The two
interesting problems are *cutting* text with parameter expansion, and
*comparing decimals*, which Bash cannot do on its own.

## Step by step
1. Validate LIMIT. The regex `^[0-9]+(\.[0-9]+)?$` accepts `2` and `1.5`, but
   not `two` or `-1`.

2. Run `uptime` once and keep the text. If the label is missing the tool is
   not what you expect, and the right response is a clear error and status 3,
   not a made-up number:

   ```bash
   out=$(uptime)
   [[ $out == *"load average: "* ]] || { echo "cannot parse uptime" >&2; exit 3; }
   ```

3. `${out##*load average: }` removes everything up to and including the label.
   Then split on commas and spaces:

   ```bash
   IFS=', ' read -r l1 l5 l15 <<< "${out##*load average: }"
   ```

   Setting IFS only for that one `read` leaves the rest of the script alone.

4. Compare decimals with a tiny helper around awk. `a + 0` forces a numeric
   comparison, and `exit !(...)` turns "true" into exit status 0:

   ```bash
   bigger() { awk -v a="$1" -v b="$2" 'BEGIN { exit !(a + 0 > b + 0) }'; }
   ```

5. Print the load line, the verdict and the trend. Save the exit status in a
   variable, because the trend lines come after the verdict.

## Try it by hand
```
./solution.sh 2
FAKE_LOAD="4.10, 3.20, 1.05" ./solution.sh 2; echo $?
FAKE_UPTIME=broken ./solution.sh 2; echo $?
```

## Alternative
Strip the dot and compare as integers (`${l1/./}`), which breaks when one number
has two decimals and the other three. Letting awk do the numeric work is both
shorter and correct.
