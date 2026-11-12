# Walkthrough: The Secret Rotator

## The plan
Rotating a credential is a distributed change: the database, a config file and a
secrets store must all agree, and there is a window in which they do not. So treat each
secret as a **transaction**. Do all the checks that cannot hurt first, make the changes in
an order that is easy to undo, prove the result, and on failure put back what you saved.
The cardinal rules of secrets handling sit on top: never print them, never log them,
never put them on a command line where `ps` can read them.

## Step by step
1. **Load the map.** `IFS='|' read -r name cfg key user` fills three associative arrays,
   and a plain array remembers the file order (associative arrays are unordered). Comments
   and blank lines are skipped. Validate every name from the command line *before* touching
   anything, so a typo in the last name does not leave a half-rotated fleet.

2. **Pre-flight checks** (step 1 and 2 of the objective): the current secret exists and the
   config actually contains `KEY=`. These come before the database change because they are
   free to fail. The old secret is read now: it is what you need for the rollback.

3. **Change the database** with `dbctl set-password`. If it refuses, nothing else has moved
   and the failure is simply reported.

4. **Rewrite the config atomically.** `mktemp "$cfg.XXXXXX"` creates a file next to the
   target (same filesystem, so `mv` is a rename and readers never see half a file).
   `cp -p` copies the permissions onto it first; the later `>` redirect truncates but does
   not change the mode. The value reaches awk through `ENVIRON`, because `-v` would put the
   secret in the process list and would also interpret backslash escapes. Before this
   rewrite the original was copied to `*.rotate-bak`.

5. **Verify and roll back.** `dbctl check` is the proof. When it fails: `mv` the backup back
   over the config and set the old password in the database. The `|| true` on that last
   call keeps the rollback going even if the database is the thing that is broken.

6. **Commit.** Delete the backup, then write the secret with `umask 077` in a subshell and
   `chmod 600` to be sure, since the file may already exist with other permissions.

7. **Report.** Failures are collected in two arrays and the summary uses
   `${ok[*]:-none}`; the exit status is 1 if any name failed. `--dry-run` shares the loop
   but prints and `continue`s.

## Try it by hand
```
./solution.sh --dry-run
./solution.sh bakery-db
cat rotation.log
ls -l conf secrets
```

## Alternative
`sed -i.bak "s/^$key=.*/$key=$new/"` is the quick way, but it breaks as soon as the secret
contains `/`, `&` or `\`, leaves the secret on the command line, and is not atomic. The
awk plus `mv` pattern costs five more lines and has none of those problems.
