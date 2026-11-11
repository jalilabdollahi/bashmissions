# Walkthrough: Running Totals

## The plan
One variable acts as the meter. It starts at 0, and every round adds the current customer's gigabytes to it. Each round prints the meter, so the output grows as the bill grows.

## Step by step
1. Initialise the accumulator before the loop: `sum=0`. If the input is empty the loop never runs, and the final line still has a real number to print.
2. Read the input with `while read -r customer gb; do`. The first word goes to `customer`, the rest of the line to `gb`.
3. Add the value: `sum=$(( sum + gb ))`. Arithmetic expansion turns the text in `gb` into a number, and the result is saved back into `sum`. The old value is the starting point of the next round.
4. Print the meter line: `echo "$customer +$gb = $sum"`. It uses the sum after adding, which is why the first line shows `= 120` for a first customer of 120.
5. After `done`, print `total=$sum`.

## Complete solution

```bash
#!/usr/bin/env bash
sum=0
while read -r customer gb; do
  sum=$(( sum + gb ))
  echo "$customer +$gb = $sum"
done
echo "total=$sum"
```

## Trying it by hand
`printf 'a 10\nb 5\n' | bash solution.sh` prints two meter lines and `total=15`. Try it with no input: `bash solution.sh < /dev/null`.

## An alternative
`awk '{ s += $2; print $1, "+" $2, "=", s } END { print "total=" s }'` does it in one line. It is the right choice for a quick report, but the Bash loop is the better one when each round also needs to call commands, check files or make decisions.
