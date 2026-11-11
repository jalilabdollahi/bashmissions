# Walkthrough: Count What Matches

## The plan
A counting loop is a tally sheet. One tally counts every line. A second tally gets a mark only when a line passes your test. At the end you read both numbers.

## Step by step
1. Initialise both counters to zero before the loop: `total=0` and `errors=0`. This also makes the empty input case correct without special code: the loop never runs and the zeros are reported.
2. Read the lines with `while read -r client status path; do`. With three variable names, `read` puts the first word in `client`, the second in `status`, and everything left in `path`. The script never needs `client` or `path`, but naming them gives the fields a place to go.
3. In the body, grow the total unconditionally: `total=$(( total + 1 ))`.
4. Ask the question: `if [[ $status == 5* ]]; then`. The star makes it a prefix match, so 500, 502 and 599 all count. Grow `errors` inside the `if`.
5. After `done`, print the single report line.

## Complete solution

```bash
#!/usr/bin/env bash
total=0
errors=0
while read -r client status path; do
  total=$(( total + 1 ))
  if [[ $status == 5* ]]; then
    errors=$(( errors + 1 ))
  fi
done
echo "server errors: $errors of $total requests"
```

## Trying it by hand
Pipe a few lines in: `printf '1.1.1.1 200 /\n2.2.2.2 500 /x\n' | bash solution.sh`. You should see 1 of 2.

## An alternative
`grep -c ' 5[0-9][0-9] '` counts matching lines in one command, which is great for a quick look. The loop version earns its keep when the rule is more than a pattern, for example "count 5xx only on the checkout path" or "also remember which client was worst".
