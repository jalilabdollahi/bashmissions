# Walkthrough: The Call Stack

## The plan
When a function runs, Bash pushes its name onto an array called `FUNCNAME` and
the line it was called from onto `BASH_LINENO`. Our `stack` function prints
those two arrays side by side, skipping itself and the top-level pseudo-entry.

## Step by step
1. Peek at the raw data first. Temporarily make `stack` print
   `declare -p FUNCNAME BASH_LINENO` and run `./solution.sh deep`:

   ```
   declare -a FUNCNAME=([0]="stack" [1]="compress" [2]="rotate_logs" [3]="nightly" [4]="main")
   declare -a BASH_LINENO=([0]="9" [1]="27" [2]="22" [3]="38" [4]="0")
   ```

   (Your numbers depend on your layout.) Index 0 is the function that is
   running now (`stack`), index 1 its caller, and so on up to `main`.

2. Pair them up. `BASH_LINENO[1]` is the line where `compress` was called,
   `BASH_LINENO[2]` where `rotate_logs` was called. The same index works in both
   arrays: `FUNCNAME[i]` was called from line `BASH_LINENO[i]`. (A frequent
   confusion: `BASH_LINENO[0]` is the line where `stack` itself was called.)

3. Loop from index 1 and stop before the last entry:

   ```bash
   stack() {
     local i
     for (( i = 1; i < ${#FUNCNAME[@]} - 1; i++ )); do
       echo "  at ${FUNCNAME[i]}, called from line ${BASH_LINENO[i]}" >&2
     done
   }
   ```

   From the top level, FUNCNAME is just `stack main`, so the loop does not run
   and nothing is printed, as required.

## Complete solution
Only `stack` is new; the other functions stay as in the starter.

```bash
stack() {
  local i
  for (( i = 1; i < ${#FUNCNAME[@]} - 1; i++ )); do
    echo "  at ${FUNCNAME[i]}, called from line ${BASH_LINENO[i]}" >&2
  done
}
```

## Try it by hand
```bash
./solution.sh deep
./solution.sh shallow
./solution.sh top
```

## Alternative
Start the loop at 0 to include `stack` itself, or print `BASH_SOURCE[i+1]` as
well to get file names. Starting at 1 is better for a report, because the
frame for `stack` is noise.
