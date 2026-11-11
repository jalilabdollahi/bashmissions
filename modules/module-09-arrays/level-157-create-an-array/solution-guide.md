# Walkthrough: Create an Array

## The plan
You have three server names and want them in a single variable. That is exactly what an array is: one name, several numbered slots. Then you will ask Bash to show you what it stored.

## Step by step
1. Keep the argument check from the starter. Exactly three arguments, otherwise a usage message on stderr and exit status 2.
2. Create the array. A normal assignment such as `rota=$1` stores one string. Round brackets turn it into a list:
   ```bash
   rota=("$1" "$2" "$3")
   ```
   Bash numbers the slots 0, 1, 2. The numbering starts at zero, which surprises almost everybody once.
3. Quote every item. `"Gull & Anchor"` arrived as one argument, and without quotes Bash would split it at the spaces and you would get four elements.
4. Print with `declare -p rota`. It is the honest view: it shows the type (`-a` means indexed array), every index and every value in quotes.

## Complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 3 ]]; then
  echo "usage: solution.sh SERVER1 SERVER2 SERVER3" >&2
  exit 2
fi
rota=("$1" "$2" "$3")
declare -p rota
```

## Trying it by hand
Run `bash solution.sh anchovy barracuda cuttlefish`. Then try `bash solution.sh "old flounder" eel dory` and notice that "old flounder" stays one element. Try removing the quotes inside the brackets and compare.

## An alternative
You could write `rota=("$@")` to grab all arguments at once. That is the usual way when the count is not fixed, and you will use it in the next levels. Here the task is exactly three, so spelling them out makes the structure visible.
