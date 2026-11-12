# Walkthrough: The Backup Verifier

## The plan
"The backup ran" and "the backup restores" are different claims, and only the second one
matters on the worst night of the year. The verifier therefore does what a disaster recovery
would do: take the archive, restore it somewhere harmless, and compare what came out with a
list of what should have gone in. The script has two layers. The outer one picks the
backups (the newest N of each set), the inner one is a function that returns the first reason a
single backup cannot be trusted.

## Step by step
1. **Options.** `--keep-last` must be a positive integer, `--set` takes a name, and the
   directory must exist. These errors exit 3 so that 1 and 2 keep their meaning for the verdict.

2. **Scratch space.** `work=$(mktemp -d)` plus `trap 'rm -rf "$work"' EXIT`. Every path
   through the script, including `exit 2` at the end, removes the restored files.

3. **Choosing backups.** A regex with two groups splits `SET-YYYY-MM-DD`; the greedy `(.+)` lets
   set names contain dashes. Print `set|date|base`, sort by set ascending and date *descending*
   (`-k2,2r`), and the first N lines of every set are the newest N. A `while read` loop watches for
   the set name changing to print each set's summary line.

4. **The cheap checks first.** Manifest present? `tar -tzf` succeeds? (A truncated or damaged
   gzip fails right there, without writing anything.) The listing is also the security check: an
   entry starting with `/` or containing a `..` component could overwrite files outside the
   restore directory, so such an archive is refused *before* `tar -x` runs.

5. **Restore and compare.** Extract with `tar -xzf ... -C "$work/restore"`. For each manifest line
   `crc size path`, the file must exist and `cksum < file` must print the same two numbers
   (reading from stdin means no file name in the output). Anything in the restore that the
   manifest did not list is also suspicious: extra files are how some tampering looks.

6. **Explaining the failure.** Three arrays collect the problems; the non-empty ones are joined with
   `; ` in a fixed order so the report is stable. A success detail counts the files.

7. **Verdict.** A set with zero good backups among those checked means you could not recover
   that system: exit 2. Any other failure is exit 1.

## Try it by hand
```
./solution.sh --keep-last 3 fixtures/backups; echo "exit=$?"
ls "${TMPDIR:-/tmp}"
```

## Alternative
Comparing archive checksums only (`cksum backup.tar.gz`) catches bit rot but not a backup of the
wrong directory, an empty database dump or a half-written archive that still has a valid CRC.
Restoring and comparing file contents is slower and answers the real question.
