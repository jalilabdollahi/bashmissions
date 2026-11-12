# Walkthrough: The Self-Updating Script

## The plan
Self-update is "download code, then run it", so every step must assume the network is lying. The script
treats the update as a series of gates, cheapest first, and only touches the installed file after the
last gate. The same structure protects against three different failures: an attacker (a bad checksum), a
broken release (a syntax error, a wrong version), and plain bad luck (a download cut short or a power cut halfway
through the install).

## Step by step
1. **Version as data.** `VERSION=1.0.0` is a constant in the script itself; after an update, the new file
   carries its own constant. `vercmp` splits both versions on dots and compares each component *numerically*,
   with `10#` so that `08` is not read as octal. Text comparison would rank `1.9.0` above `1.10.0`.

2. **Ask, validate, compare.** `VERSION` is fetched into the scratch directory. Whatever the server says is
   input: if it is not three numbers the update stops with exit 3. Then the comparison decides: newer continues, equal
   is "up to date" (unless `--force`), older is a **downgrade** and refused even with `--force`, because a
   compromised server could use "the latest is 0.5.0" to push you back onto a vulnerable release.
   `--check` stops here with its own exit status 10, "an update is available", so wrapper scripts can react.

3. **Download into a scratch directory.** `mktemp -d` plus a `trap` guarantees nothing is left on failure.
   Both the script and its checksum file must arrive.

4. **Verify before installing.** (a) `cksum < file` gives the CRC and the size; both must equal the checksum file's
   fields. (b) `bash -n` parses the script without executing it. (c) `bash new.sh version` runs the *new* script once
   and requires it to say exactly `lantern X.Y.Z`: a release that is valid Bash but is the wrong build is
   caught here. Each failure has a precise message and exit 5.

5. **Install atomically.** Keep the current script as `$0.old` (for `rollback`). Prepare the new one *next to* the
   old: `cp -p` gives the same permissions, `cat` fills it, and one `mv` swaps it over `$0`. A rename is atomic
   within a filesystem, so every observer sees either the old script or the new one, never half of each. And because
   `mv` creates a different file (a new inode), the running Bash keeps reading the old one. Writing into `$0` would
   instead corrupt the script while it is running.

6. **Leave at once.** After the final `echo`, `exit 0`. The file on disk is no longer the one that was started; the
   safest thing to do with a replaced script is to stop reading it.

7. **`rollback`.** Ask the saved copy for its version, `mv` it over `$0`, report. No backup means nothing to do.

## Try it by hand
```
./solution.sh update --check; echo "exit=$?"
./solution.sh update
./solution.sh version
./solution.sh rollback
```

## Alternative
`curl ... | bash` is the famous one-liner, and the opposite of everything above: it runs unverified code as it
arrives, and a connection that drops half-way executes half a script. Even `curl -o file && bash file`
without a checksum trusts whoever controls the server or a proxy on the path.
