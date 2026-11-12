# Common Mistakes

- **A bare `cd` in a loop.** The second iteration starts where the first one ended.
  - Wrong: `for d in "$@"; do cd "$d"; sitebuild; done`
  - Right: `( cd "$d" && sitebuild )`
- **Using `;` instead of `&&` after the cd.** If `cd` fails, the build runs in the wrong folder.
  - Wrong: `( cd "$d"; sitebuild )`
  - Right: `( cd "$d" && sitebuild )`
- **Writing result files by relative path inside the subshell.** There, "current folder" is the site folder, not yours.
  - Wrong: `( cd "$d" && sitebuild && echo ok >> report.txt )` writes into the site.
  - Right: record the status outside the parentheses, or use `$start/report.txt`.
- **Expecting a variable set inside the parentheses to survive.** Counting `built` inside ( ) leaves the counter unchanged outside.
  - Right: increment the counter after the `if`, in the main shell.
- **Undoing with `cd ..`.** It fails on `a/b/deep` paths and after a failed cd.
