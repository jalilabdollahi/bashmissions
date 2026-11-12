# Walkthrough: Where Was This Defined?

## The plan
We need to answer two questions inside one file: "where was this function
defined?" (for the label) and "am I being run or being loaded?" (for the guard).
Both have a one-line answer in `BASH_SOURCE`.

## Step by step
1. `BASH_SOURCE` is an array of file names that parallels the call stack. Entry
   0 is the file whose code is executing right now. Inside `host_label`
   that is the file where the function was written, no matter who calls it:

   ```bash
   host_label() {
     echo "host: $1 (defined in $(basename "${BASH_SOURCE[0]}"))"
   }
   ```

   `basename` trims `./` or a long path down to `solution.sh`.

2. The guard. `$0` is the script the user started. If you run
   `./solution.sh eel`, both are `./solution.sh`. If another script runs
   `source ./solution.sh`, `$0` is that other script, while `BASH_SOURCE[0]` is
   still `./solution.sh`. So the check

   ```bash
   if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
     main "$@"
   fi
   ```

   is true only when the file is executed.

3. Try both ways:

   ```
   $ ./solution.sh anchovy
   host: anchovy (defined in solution.sh)
   $ bash -c 'source ./solution.sh; host_label eel'
   host: eel (defined in solution.sh)
   ```

## Complete solution
```bash
#!/usr/bin/env bash
set -u
host_label() {
  echo "host: $1 (defined in $(basename "${BASH_SOURCE[0]}"))"
}
main() {
  if (( $# == 0 )); then
    echo "usage: solution.sh HOSTNAME" >&2
    exit 2
  fi
  host_label "$1"
}
if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  main "$@"
fi
```

## Try it by hand
```bash
./solution.sh anchovy
./solution.sh; echo "status=$?"
bash -c 'source ./solution.sh; host_label eel'
```

## Alternative
`$0` alone would make `host_label` claim it was defined in whatever script
loaded the library (here, `bash`), which is exactly the confusion we are
removing. `BASH_SOURCE[0]` is the right tool; in a library you also use it to
find files next to the library: `dir=$(dirname "${BASH_SOURCE[0]}")`.
