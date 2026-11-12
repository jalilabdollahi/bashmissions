# Common Mistakes

- **Typing the name instead of reading `$0`.** It goes stale as soon as the file is renamed.
  Wrong: `echo "This script is called solution.sh"`
  Right: `echo "This script is called $(basename "$0")"`
- **Forgetting quotes around the path.** `Q3 totals.txt` becomes two arguments to basename.
  Wrong: `basename $REPORT_PATH`
  Right: `basename "$REPORT_PATH"`
- **Using basename without a substitution.** `echo "Report file: basename $REPORT_PATH"` prints the word basename.
- **Expecting `$0` to hold only the file name.** Run as `./tools/solution.sh` it holds the folders too.
