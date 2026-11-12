# Walkthrough: The Grand Finale

## The plan
`lantern` is the front door to everything the on-call person needs: are the services up (`health`), are the backups usable (`backups`), what does it all add up to (`report`), and may I give someone else the pager (`handover`). It is a *CLI with subcommands*, so the structure is: a small set of functions that each do one job and print their findings, and a dispatcher that combines them.

The design rule is "functions print lines and set counters; commands add summaries and exit codes". `do_health` and `do_backups` print one line per item and set variables such as `h_down` and `b_stale`. `health` and `backups` print a summary and choose an exit code. `report` calls both and turns the counters into a verdict. `handover` calls `report` silently and obeys its verdict. Logic written once, reused three times.

## Step by step

1. **Dates without `date -d`.** `valid_date` checks the shape (`YYYYMMDD`), the month, and the day against the month's length, with the Gregorian leap-year rule (every 4 years, except centuries, except every 400). `days_of` converts a date to a day number with the "days from civil" algorithm: treat March as the first month so the leap day is the last day of the shifted year, then add up eras of 400 years (146097 days), years within the era, and days within the year. Subtracting two day numbers gives an age that is right across month ends, leap days, new years and even the year 1900 (which is *not* a leap year).

2. **Health.** For each `NAME URL` line, `curl -s -o /dev/null -w '%{http_code}'` prints only the status. A refused or unresolvable connection prints `000` and curl exits non-zero; under `set -e` that would kill the script, so the call ends with `|| true` and a regex normalises anything odd to `000`. `case` patterns (`2??`, `3??|4??`) classify. Only a DOWN service makes `health` exit 1.

3. **Backups.** Group files by name using a regex with two capture groups and keep only the newest date per name in an associative array: yesterday's good backup does not excuse a corrupt one today. Then judge in a fixed order: a sum file that disagrees (`CORRUPT`) beats a missing sum file (`NOSUM`) beats an old backup (`STALE`) beats `ok`. The sum comparison uses `cksum < file`, the same fingerprint idea as in the evidence and migration missions.

4. **The verdict.** Three words with strictly increasing severity. RED means "act now" (a service down, a backup corrupt or stale, no backups at all). AMBER means "look soon" (a warning, a backup that cannot be verified). The exit codes 0, 1 and 3 let a cron job or another script react without parsing text.

5. **The gated handover.** The last rule is a *policy*: nobody takes the pager on a bad night. The command re-runs the report with its output discarded, refuses unless the verdict is GREEN, and only then changes anything. Writing `oncall.txt` and appending to `handover.log` is the same "current state plus append-only history" pattern as the ledger and the audit trail.

## Complete solution
The two pieces worth remembering:
```bash
code=$(curl -s -o /dev/null -w '%{http_code}' "$url" 2>/dev/null) || true
[[ $code =~ ^[0-9]{3}$ ]] || code=000

(( m <= 2 )) && y=$((y - 1))
era=$(( (y >= 0 ? y : y - 399) / 400 )); yoe=$((y - era * 400))
mp=$(( m > 2 ? m - 3 : m + 9 )); doy=$(( (153 * mp + 2) / 5 + d - 1 ))
doe=$(( yoe * 365 + yoe / 4 - yoe / 100 + doy )); DAYS=$(( era * 146097 + doe - 719468 ))
```

## Try it by hand
```bash
printf 'shop http://shop.lanternfish.example/health\n' > services.conf
printf 'shop.lanternfish.example 200\n' > net.txt
./solution.sh health
./solution.sh report 20261112
```
(`curl` is a stub that reads `net.txt`.)

## Alternative
A set of separate scripts (`lantern-health`, `lantern-backups`) works, and `git` and `docker` are built exactly that way. A single script with subcommands keeps shared code (dates, formats) in one place and makes `lantern --help` possible.
