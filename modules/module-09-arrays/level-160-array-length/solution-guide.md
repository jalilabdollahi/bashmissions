# Walkthrough: Array Length

## The plan
Two numbers, two different questions: "how many elements?" and "how many characters in the first element?". Bash has one syntax with a small change for each.

## Step by step
1. Build the array from the arguments: `fleet=("$@")`.
2. For the number of elements use `${#fleet[@]}`. The hash asks for a length, and `[@]` says "of the whole list".
3. For the width of the first name use `${#fleet[0]}`. With an index, the hash measures that single element as a string.
4. Notice the starter's mistake: `${#fleet}` has no subscript, so Bash treats it as `${#fleet[0]}`, the characters in element 0. That is exactly the bug in Theo's draft.
5. The empty case needs no special code. With no arguments there are zero elements, and the length of a missing element is also 0.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
fleet=("$@")
echo "servers: ${#fleet[@]}"
echo "first tag width: ${#fleet[0]}"
```

## Trying it by hand
Run `bash solution.sh anchovy barracuda` (servers 2, width 7). Then `bash solution.sh "two words" x` to see that spaces count as characters but not as separators when quoted. Finally run it with no arguments.

## An alternative
You could count with a loop, adding 1 for every element. It works but is longer and slower; the length expansion exists precisely so you do not have to. For the character count, `wc -c` would also work but starts a process and counts the newline too.
