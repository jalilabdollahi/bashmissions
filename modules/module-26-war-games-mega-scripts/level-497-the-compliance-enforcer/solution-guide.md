# Walkthrough: The Compliance Enforcer

## The plan
A compliance policy is a list of statements about a system: "shadow is mode 0600", "root cannot log in over SSH". The classic failure is a policy that lives in a document, so nobody can say whether it is true *now*. Our policy is a file of rules, and one engine reads it and does three things: **check** (report), **enforce** (fix and verify) and **dry-run** (show the fix without making it). The most important line of the whole design is that `enforce` calls `evaluate` again after every fix. Verified compliance is a measurement; an applied fix is only an intention.

## Step by step

1. **Parse before acting.** Each rule line is `ID SEVERITY TYPE PATH [ARGUMENTS]`. `read -r id s t p r` leaves the rest of the line in `r`, spaces included, which is exactly what the `line` text or a `noline` regex needs. All problems in the file are reported together, and nothing is evaluated until the file is clean. Paths are confined to the root (no leading `/`, no `..`), so a rule can never reach outside the tree it is meant to police.

2. **Waivers have an expiry.** A waiver is a decision made by a human, and decisions go stale. The main loop checks the waiver first: valid means skip and say so; expired means say so on stderr and enforce normally. With the time passed in as NOW, expiry is plain arithmetic.

3. **Read modes without `stat`.** `ls -ld` prints the permission string, `-rw-r--r--`. Walking its nine characters and adding 4, 2 or 1 for `r`, `w`, `x` in each group gives an octal mode. `${perms:i:1}` extracts one character. Modes are normalised to four digits so that `600` and `0600` are the same thing.

4. **One function per rule type.** `evaluate` has a `case` with five small branches and sets a message on failure. `can_fix` encodes what is *impossible*: you cannot chmod a missing file, delete a directory with a file-level rule, or create a file in a folder that does not exist. Saying "CANNOT FIX" honestly is better than crashing or pretending.

5. **Back up first, change second, keep the mode.** Before the first change to a file, `cp -p` stores the original (with its mode and timestamps) in `.compliance-backup/PATH`, once, never overwriting. Rewriting a file needs care: `mktemp` creates a file with mode 0600, and `mv` would give `etc/passwd` that mode. Writing the new content *over* the old file with `cat "$tmp" > "$file"` keeps the original inode and permissions.

6. **Verify.** After `apply_fix`, call `evaluate` again: PASS becomes `FIXED`, anything else `STILL FAILING`. The summary counts each outcome, and the exit status makes the tool usable as a gate in CI and cron.

## Complete solution
The verify-after-fix core:
```bash
fix_text "$id"
if (( dry )); then echo "WOULD FIX $id ($s): $fixtext"; continue; fi
apply_fix "$id"
if evaluate "$id"; then echo "FIXED $id ($s): $fixtext"; else echo "STILL FAILING $id ($s): $msg"; fi
```

## Try it by hand
```bash
./solution.sh check srv fixtures/policy.rules 1700000000
./solution.sh --dry-run enforce srv fixtures/policy.rules 1700000000
./solution.sh enforce srv fixtures/policy.rules 1700000000; ls -l srv/.compliance-backup/etc
```
(Create a small `srv/` tree first, like the one in the tests.)

## Alternative
Configuration-management tools (Ansible, Puppet) express the same idea declaratively and ship hundreds of rule types. Writing the engine once by hand shows what they do under the hood, including why "check mode" and "diff mode" exist.
