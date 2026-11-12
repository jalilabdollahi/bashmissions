# Walkthrough: Skip with continue

## The plan
Go through every argument. If the code looks like a test account, drop it and pick up the next one. Otherwise bill it.

## Step by step
1. Loop over the arguments with `for code in "$@"; do`. If you pass no arguments, the loop body runs zero times, which already covers the empty case.
2. Test the prefix with a glob: `[[ $code == TEST-* ]]`. On the right side of `==` inside `[[ ]]`, `*` means "anything". `TEST-` followed by anything matches `TEST-001`, but not `TESTING` (no dash) and not `NORTH-TEST-5` (the pattern is anchored at the start).
3. When it matches, run `continue`. The rest of the body is skipped and the loop moves on to the next code.
4. After the `if`, print `billing $code`. Only non-test codes get here.

## Complete solution

```bash
#!/usr/bin/env bash
for code in "$@"; do
  if [[ $code == TEST-* ]]; then
    continue
  fi
  echo "billing $code"
done
```

## Trying it by hand
`bash solution.sh HB-017 TEST-001 GA-9` should print two lines. Then try `bash solution.sh TESTING`: it is billed, because the dash is part of the prefix you promised to skip.

## An alternative
Invert the test and put the billing line inside the `if`: `if [[ $code != TEST-* ]]; then echo ...; fi`. Both work. `continue` becomes more valuable when the body is long and you have several reasons to skip: each reason is a short guard at the top, and the real work stays unindented below.
