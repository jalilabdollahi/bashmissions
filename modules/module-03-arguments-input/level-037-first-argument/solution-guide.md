# Walkthrough: First Argument

## The plan
The script has one input, the customer name, and one output, a greeting. Bash
hands every word typed after the script name to the script as a numbered
variable. The first word is `$1`.

## Building it
Start with the greeting you want, written with a fixed name:

```bash
echo "Ahoy, Harbour! Your Lanternfish account is ready."
```

Now swap the fixed name for the variable that holds whatever the caller typed:

```bash
echo "Ahoy, $1! Your Lanternfish account is ready."
```

Variables expand inside double quotes, so the text around `$1` stays as written.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
echo "Ahoy, $1! Your Lanternfish account is ready."
```

## Try it by hand
```bash
./solution.sh Harbour
./solution.sh "Tidewater Books"
./solution.sh Tidewater Books    # only "Tidewater" is $1 here!
```
The last call shows why Noor must quote names with spaces: the shell splits the
line into words before your script ever runs, and `Books` becomes `$2`.

## Alternative
You could copy the argument into a named variable first (`customer=$1`) and print
`$customer`. That is nicer in long scripts because the name explains itself; for a
one-liner, using `$1` directly is perfectly fine.
