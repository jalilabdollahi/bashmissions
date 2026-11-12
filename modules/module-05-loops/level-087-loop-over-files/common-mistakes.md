# Common Mistakes

- **Not enabling `nullglob`.** The loop runs once for a pattern that matched nothing.
  Symptom: `wc: logs/*.log: No such file or directory` on an empty folder
  Fix: `shopt -s nullglob` before the loop
- **Parsing `ls`.** Spaces split the names.
  Wrong: `for f in $(ls logs)` turns `final FINAL v2.log` into three items
  Right: `for f in logs/*.log`
- **Forgetting to quote the variable.** `wc -l < $file` fails for a name with spaces ("ambiguous redirect").
  Right: `wc -l < "$file"`
- **Quoting the glob.** Quotes switch the wildcard off.
  Wrong: `for f in "logs/*.log"` runs once with the literal text
  Right: `for f in logs/*.log`
