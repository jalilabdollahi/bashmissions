# Walkthrough: All Elements Safely

## The plan
Put the customers in an array, then expand all of them in a way that keeps every name in one piece, and print each with the prefix `invoice: `.

## Step by step
1. `customers=("$@")` builds the array. This is the same as before.
2. Think about what must happen to the names. Bash expands a variable and then, unless the expansion is quoted, splits the result at spaces and expands any `*` into file names. That is how "Tidewater Books" becomes two words and "*" becomes a file list.
3. `"${customers[@]}"` is the cure. With the double quotes and the `@`, Bash produces exactly one word per element and performs no splitting or globbing on them.
4. `printf 'invoice: %s\n' "${customers[@]}"` then prints one line per element, because printf repeats its format string until it has used all of its arguments.
5. Mind the empty case. With zero arguments printf still runs the format once, printing `invoice: ` with nothing after it. Wrap the call in a check that the array is not empty.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
customers=("$@")
if (( ${#customers[@]} > 0 )); then
  printf 'invoice: %s\n' "${customers[@]}"
fi
```

## Trying it by hand
Run `bash solution.sh "Tidewater Books" "*"` and then, to see the difference, change the quoted expansion to `${customers[@]}` without quotes. The star becomes a list of the files in your workspace.

## An alternative
A `for name in "${customers[@]}"; do echo "invoice: $name"; done` loop gives the same result and is easier to extend. Loops over arrays are the topic of a later level.
