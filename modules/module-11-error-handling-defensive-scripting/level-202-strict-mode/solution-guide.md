# Walkthrough: Strict Mode

## The plan
The four steps are already written; what is missing is the line that makes the
script stop when a step goes wrong, plus the final report. Strict mode is three
protections in one command:

| flag | stops on | in this script |
|---|---|---|
| `-e` | a command that fails | missing `sites/SITE.conf` makes `cp` fail |
| `-u` | an unset variable | `BACKUP_DIR` missing would make the path `/dory` |
| `-o pipefail` | a failing pipeline stage | `pullstats` crashes while `sort` succeeds |

## Step by step
1. Right under the shebang:

   ```bash
   set -euo pipefail
   ```

2. Keep the three working commands as they are. With the safety line in place
   each one is guarded without any extra code.

3. Count the lines and report. `wc -l < file` reads from stdin, so the output is
   just a number (macOS pads it with spaces; `$(( ... ))` removes them):

   ```bash
   lines=$(wc -l < "$BACKUP_DIR/$1/stats.txt")
   echo "archived $1: $(( lines )) lines"
   ```

   Because this is the last line, it can only run when everything before it
   worked.

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$BACKUP_DIR/$1"
pullstats "$1" | sort > "$BACKUP_DIR/$1/stats.txt"
cp "sites/$1.conf" "$BACKUP_DIR/$1/site.conf"
lines=$(wc -l < "$BACKUP_DIR/$1/stats.txt")
echo "archived $1: $(( lines )) lines"
```

## Try it by hand
```bash
mkdir -p sites; echo port=1 > sites/dory.conf
BACKUP_DIR=/tmp/bk ./solution.sh dory
./solution.sh dory; echo "exit=$?"            # unbound variable
FAKE_STATS_FAIL=1 BACKUP_DIR=/tmp/bk ./solution.sh dory; echo "exit=$?"
```

## Alternative
Three lines (`set -e`, `set -u`, `set -o pipefail`) behave identically. The
single line is the community habit, so recognising it matters when you read
other people's scripts.
