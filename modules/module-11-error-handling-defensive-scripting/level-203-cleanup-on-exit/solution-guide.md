# Walkthrough: Cleanup on Exit

## The plan
The lock is created in the middle of the script, and the script can leave at
three places: the end, a crash caused by `set -e`, or an explicit `exit`. Instead
of repeating the removal at each of them, we register it once and let Bash call
it on the way out.

## Step by step
1. Enable `set -e` first, so a failed `lanternbuild` ends the script on the spot.

2. Write the cleanup as a small function. Two things to do: delete the file and
   say so. `rm -f` does not complain if the file is already gone.

   ```bash
   release_lock() {
     rm -f deploy.lock
     echo "lock released"
   }
   ```

3. Create the lock, then immediately register the trap. The order matters: if
   the trap came later, a crash in between would leave the lock behind; if it
   came before the `touch`, the cleanup would still be harmless thanks to `-f`.

   ```bash
   touch deploy.lock
   trap release_lock EXIT
   ```

4. Run the build and print the success line.

## Complete solution
```bash
#!/usr/bin/env bash
set -e
release_lock() { rm -f deploy.lock; echo "lock released"; }
touch deploy.lock
trap release_lock EXIT
lanternbuild
echo "deploy finished"
```

## Try it by hand
```bash
./solution.sh; ls deploy.lock                          # gone
FAKE_BUILD_STATUS=4 ./solution.sh; echo "exit=$?"      # 4, lock still gone
```

## Alternative
Deleting the lock at the end of the script and again inside every error branch
works until someone adds a new `exit`. The trap moves the promise to one place
that cannot be forgotten.
