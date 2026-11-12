# Common Mistakes

- **Counting with grep.** Wrong: `grep -c 'ok' run.tap` counts `not ok`, comments and diagnostics. Right: match `^ok ` and `^not ok ` at the start of the line.
- **Matching loosely.** Wrong: `[[ $line == *ok* ]]` treats `not ok 4` as a pass, because it contains `ok`. Right: capture the status with `(not\ ok|ok)` at the start of the line and compare it.
- **Treating TODO and SKIP as ordinary results.** Wrong: counting `not ok 4 # TODO unfinished` as a failure turns the build red for known work in progress. Right: check the directive before counting.
- **Skipping the plan.** Wrong: exiting 0 because every printed result passed, when the file says `1..5` and only three ran. Right: compare the planned number with the results you actually saw.
- **Unquoted space in the regex.** Wrong: `[[ $l =~ ^(not ok)... ]]` is a syntax error. Right: `not\ ok`, or store the pattern in a variable and use `=~ $re`.
