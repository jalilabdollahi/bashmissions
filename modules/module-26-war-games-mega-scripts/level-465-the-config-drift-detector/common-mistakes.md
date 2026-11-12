# Common Mistakes

- **Comparing raw text.** Wrong: `diff golden/x.conf live/x.conf`. A reordered key or a comment change is reported as drift. Right: normalise (trim, drop comments, strip quotes) and compare the settings.
- **Printing secrets in the report.** Wrong: `~ db_password: correct-horse -> hunter2`. Right: compare the real values, display `***` when the key looks sensitive.
- **Letting ignored keys leak into the maps.** Wrong: filtering them only when printing, so a file with only an ignored change still counts as drifted. Right: drop them before they are stored.
- **Using `stat` for modes.** Wrong: `stat -c %a` (GNU) or `stat -f %Lp` (BSD) breaks one platform. Right: parse `ls -l` and convert each `rwx` triple.
- **Treating the control files as managed.** Wrong: `.modes` shows up as MISSING in live. Right: exclude `.modes` and `.ignore` from the golden path list.
- **Auto-fixing.** Wrong: running `cp` and `chmod` directly on production. Right: print a plan with the exact commands for review.
