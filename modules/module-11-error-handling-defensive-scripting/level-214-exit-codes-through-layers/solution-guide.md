# Walkthrough: Exit Codes Through Layers

## The plan
A status can be lost at four hand-offs. We secure each one in turn.

```
lanternci --(pipe)--> tee --(function)--> run_stage --(caller)--> main script
```

## Step by step
1. **Out of the pipe.** The status of `lanternci "$1" 2>&1 | tee "$1.log"` is
   tee's, which is nearly always 0. Two fixes, either is accepted here:

   - `set -o pipefail` at the top, then `$?` is the right-most failing stage;
   - `${PIPESTATUS[0]}`, an array holding every stage's status of the *last*
     pipeline: element 0 is lanternci. Read it on the very next line, because the
     next command replaces the array.

2. **Out of the function.** Capture and test it, say what happened on stderr and
   `return` the number. A function cannot "exit with a status" except through
   `return`; the status then becomes the function call's `$?`.

   ```bash
   status=${PIPESTATUS[0]}
   if (( status != 0 )); then
     echo "[$1] failed with status $status" >&2
     return "$status"
   fi
   ```

3. **Into the main script.** `run_stage test || exit $?` means: if the call
   failed, leave with the number it returned. Right at that point `$?` is still
   the function's status. Because the script stops there, `ship` never runs and
   writes no log.

4. After the three calls, print "deployed".

## Complete solution
See `answer.sh`. It uses both techniques so you can compare them: `pipefail`
for safety everywhere and `PIPESTATUS[0]` for the exact number.

## Try it by hand
```bash
FAKE_CI_FAIL_STAGE=test FAKE_CI_CODE=42 ./solution.sh; echo "exit=$?"   # 42
ls *.log                                                                 # no ship.log
```

## Alternative
`set -e` plus `pipefail` makes the script stop on its own, but the exit status is
then whatever `set -e` saw, and you lose the chance to print "[test] failed".
Explicit `return` and `|| exit $?` keep the story visible in the code.
