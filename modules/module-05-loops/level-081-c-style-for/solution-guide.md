# Walkthrough: C-Style for

## The plan
Count from the given number down to 1 and print a line each time, then announce the deploy. The tricky part is only that the starting number is not known when you write the script.

## Step by step
1. Check the argument with `[[ $# -lt 1 ]]`. If it is missing, write the usage line to stderr and `exit 2`.
2. Store the argument: `seconds=$1`.
3. Write the three-part loop header: `for (( i = seconds; i >= 1; i-- )); do`. Inside the double parentheses you are in arithmetic mode, so variables need no dollar sign and spaces are allowed.
   - `i = seconds` runs once, before the first round.
   - `i >= 1` is checked before every round; when it turns false the loop ends.
   - `i--` runs after every round and lowers the counter.
4. Print `T-$i` in the body. Here the dollar sign is needed because we are back in normal string mode.
5. After `done`, print `deploy!`.

## Complete solution

```bash
#!/usr/bin/env bash
if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh SECONDS" >&2
  exit 2
fi

seconds=$1
for (( i = seconds; i >= 1; i-- )); do
  echo "T-$i"
done
echo "deploy!"
```

## Trying it by hand
`bash solution.sh 3`, then `bash solution.sh 0`. For zero, the check `0 >= 1` fails immediately and the body never runs; only the closing line appears.

## An alternative
`seq "$seconds" -1 1` also counts down and works in a `for i in $(seq ...)`. It is fine, but the C-style loop needs no extra process and lets you express any rule for the counter, such as doubling or stepping by five.
