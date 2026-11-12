# Walkthrough: The User Auditor

## The plan
An audit is a set of independent questions asked of the same list of accounts: is anyone
sharing root's identity, is anyone without a password, who has not logged in, whose home
directory is missing, who left a private key readable by the world, and which directories
belong to nobody. Answering them all in one pass over `passwd` needs the other files to be
lookups, so the script first loads them into associative arrays. Every question appends a
uniform record to one array; the report is produced at the end from that array.

## Step by step
1. **Options.** A `while`/`case` loop reads `--stale-days N` (validated) and any number of
   `--ignore USER`, which simply sets `skip[USER]=1`. After the loop exactly three
   positional arguments must remain, and each one must be readable. Usage mistakes are exit 2.

2. **Lookups.** `hash[user]` from SHADOW and `lastseen[user]` from LASTLOG. Both loops skip
   blanks and comments. Later `${hash[$user]+set}` distinguishes "listed with an empty
   password" (a finding) from "not listed at all" (not this check's business).

3. **Findings as records.** `add RANK KIND USER DETAIL` pushes `RANK|KIND|USER|SEV|DETAIL`.
   The rank is a number so that one `sort` can order CRIT before WARN before INFO.

4. **The passwd loop.** `IFS=: read -r user _ uid _ _ home shell`. Order matters: record the
   home directory as owned *before* honouring `--ignore`, otherwise an ignored user's home
   would be reported as an orphan. Then the checks: uid 0 under another name; a repeated uid
   (the first owner is remembered in `uid_owner`); and, only for real users (uid >= 1000), the
   login-shell checks (`*nologin` and `*false` are not login shells), NOPASS, STALE.

5. **Home directories.** A missing directory is NOHOME. An existing one has its key files
   inspected. `ls -l file | cut -c1-10` yields something like `-rw-r--r--` everywhere, which
   avoids `stat`, whose flags differ between macOS and Linux. Characters 5 to 10 are group and
   other: all dashes means private. For `authorized_keys` only the write bits matter.

6. **Orphans.** `for d in home/*/` lists the directories; one that no passwd line points to
   is INFO. Guard with `[[ -d $d ]]` because an empty glob stays as literal text.

7. **Report.** The header and rows share one printf format. The detail is rebuilt from field 5
   onward in awk, in case it contains `|`. The summary counts by rank and the exit status is
   1 if anything was found.

## Try it by hand
```
./solution.sh --ignore deploy passwd shadow lastlog; echo "exit=$?"
```

## Alternative
`getent`, `lastlog` and `stat` would be the real tools on one Linux box. The input files make
the script testable and portable, and a "dump the facts, audit the dump" split also lets you
audit a machine you cannot log in to.
