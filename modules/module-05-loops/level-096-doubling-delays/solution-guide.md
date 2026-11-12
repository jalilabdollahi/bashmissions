# Walkthrough: Doubling Delays

## The plan
Simulate the retries without waiting. Each round decides this attempt's delay, prints it, adds it to a total, and prepares the next, doubled delay. A cap keeps the numbers sane.

## Step by step
1. Validate: fewer than three arguments is a usage error, exit 2. Then name the inputs: `base`, `attempts`, `cap`.
2. Set the state before the loop: `delay=$base` and `total=0`.
3. Loop over the attempts with `for (( k = 1; k <= attempts; k++ ))`. With 0 attempts the loop does not run and only the total line prints.
4. Apply the cap: `if (( delay > cap )); then delay=$cap; fi`. Doing it before printing also handles a base that starts above the cap.
5. Print the attempt line, then `total=$(( total + delay ))`.
6. Double for the next round: `delay=$(( delay * 2 ))`. Because the cap is applied at the top of every round, a delay that overshoots (say 16 with a cap of 10) is simply cut back next time.
7. After the loop, print `total wait: ${total}s`. Braces around `total` keep the `s` from being read as part of the name.

## Complete solution

```bash
#!/usr/bin/env bash
if [[ $# -lt 3 ]]; then
  echo "usage: solution.sh BASE ATTEMPTS CAP" >&2
  exit 2
fi
base=$1; attempts=$2; cap=$3
delay=$base
total=0
for (( k = 1; k <= attempts; k++ )); do
  if (( delay > cap )); then delay=$cap; fi
  echo "attempt $k: wait ${delay}s"
  total=$(( total + delay ))
  delay=$(( delay * 2 ))
done
echo "total wait: ${total}s"
```

## Trying it by hand
`bash solution.sh 1 6 20` shows 1 2 4 8 16 20. In a real retry loop you would put `sleep "$delay"` right after the print.

## An alternative
`delay=$(( delay << 1 ))` doubles using a bit shift, and `delay=$(( delay > cap ? cap : delay ))` caps in one line with the ternary operator. Both are fine; the plain multiplication and the `if` are easier to read for the next person.
