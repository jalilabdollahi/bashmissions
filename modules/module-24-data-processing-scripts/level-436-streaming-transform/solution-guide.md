# Walkthrough: Streaming Transform

## The plan
A streaming filter keeps a fixed amount of state, handles each line the moment
it arrives, and writes its result immediately. Here the state is the running
total in cents and a count of good rows; everything else is forgotten as soon
as the line has been printed.

## Step by step
1. **Read stdin, write stdout.** An awk program with no file argument reads the
   script's standard input, so `./solution.sh < payments.csv` and
   `tail -f stream | ./solution.sh` both work. Each `print` is output the
   moment its input line is processed.

2. **Header and noise.** `NR == 1` prints the new header and skips to the next
   line. Blank lines are skipped (they still advance `NR`, which is what
   `bad line N` reports). `sub(/\r$/, "")` tidies Windows lines.

3. **Validate.** A good row has exactly two fields, a non-empty `ts`, and cents
   that match `^-?[0-9]+$`. Anything else is reported to stderr with the line
   number and the line text, and skipped.

4. **Integer money.** `running += $2` adds cents. `dollars(c)` turns cents
   into text: remember the sign, make `c` positive, then `int(c / 100)` gives
   whole dollars and `c % 100` the cents, written `%02d` so 7 becomes `07`.
   No floating point means no `0.07000000001`.
   Whole dollars are printed with `%.0f`, which stays exact for big values on
   every awk (some print `%d` as 32-bit).

5. **Finish.** `END` runs when the input ends. If anything was read (`NR > 0`),
   print the summary.

## Complete solution
See `answer.sh`.

## Try it by hand
```bash
printf 'ts,cents\nt1,1250\nt2,-305\n' | ./solution.sh
yes 't,100' | head -1000000 | { echo ts,cents; cat; } | ./solution.sh | tail -1
```

## Alternative
Reading everything into an array (or a temp file) and processing it afterwards
gives the same output for small input, but it needs memory (or disk)
proportional to the input, delays every result until the end, and cannot work on
a stream that never ends.
