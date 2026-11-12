# Common Mistakes

- **Using `SECONDS` for sub-second work.** Wrong: `SECONDS` differences are whole numbers, so `sleep 0.3` reports 0 and `sleep 1` might report 0 or 2. Right: `EPOCHREALTIME` in microseconds.
- **Doing arithmetic with the dot.** Wrong: `$(( EPOCHREALTIME - start ))` fails with a syntax error because Bash integers have no decimals. Right: strip the dot first with `${EPOCHREALTIME/./}`.
- **Printing `.47` instead of `.047`.** Wrong: `printf '%d.%d'` drops the leading zeros of the milliseconds. Right: `%d.%03d`.
- **Losing the report when the command fails.** Wrong: a bare `"$@"` under `set -e` exits before the timing line, so slow failures are invisible. Right: `"$@" || rc=$?`, report, `return "$rc"`.
- **Timing the wrong thing.** Reading the start after running, or putting the report on stdout (mixing it into the command's data). Take the first reading right before `"$@"` and print to stderr.
