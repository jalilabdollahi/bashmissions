# Common Mistakes

- **Using `date -d` or `date -j` for age.** One is GNU-only, the other BSD-only. Convert both dates to day numbers with integer arithmetic and subtract.
- **Forgetting that 1900 was not a leap year.** "Divisible by 4" is not the whole rule: centuries count only when divisible by 400. A hand-rolled `y % 4 == 0` is wrong for 1900 and 2100.
- **Letting a failed `curl` stop the script.** With `set -e`, a refused connection (exit 6) ends the run before the line for that service is printed. Finish the call with `|| true` and treat a non-numeric result as `000`.
- **Checking every backup instead of the newest.** An old good backup hides today's corrupt one. Group by name and examine only the latest.
- **Comparing checksums as loose text.** `cksum file` prints the file name too, and `$(cksum < f)` differs from the sum file if you leave trailing spaces. Read the stored numbers with `read -r a b` and compare `"$a $b"`.
- **Handover logic that re-implements the checks.** Copy-pasting the report's rules into `handover` guarantees they drift apart. Call the same function and look at its verdict.
- **Octal dates.** `$(( 08 ))` and `$(( 09 ))` fail. Slice with `${s:4:2}` and force decimal with `10#`.
