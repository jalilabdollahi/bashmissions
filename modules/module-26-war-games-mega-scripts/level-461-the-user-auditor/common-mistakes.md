# Common Mistakes

- **Mixing up empty and missing.** Wrong: `[[ -z ${hash[$user]} ]]` flags every user who is simply absent from shadow (and fails under `set -u`). Right: `[[ -n ${hash[$user]+set} && -z ${hash[$user]} ]]`.
- **Skipping the ignored user too early.** Wrong: `continue` before recording the home directory: the allow-listed user's home is then reported as an orphan. Right: record `homedirs[$dir]=1` first.
- **Using `stat` for modes.** Wrong: `stat -c %a file` (GNU) or `stat -f %Lp file` (BSD) breaks one platform. Right: `ls -l file | cut -c1-10`.
- **Counting `nologin` users as stale.** Wrong: auditing every uid >= 1000. Right: only accounts with a login shell can have forgotten to log in.
- **Treating every glob match as a directory.** Wrong: `for d in home/*/` when home/ is empty yields the literal `home/*/`. Right: `[[ -d $d ]] || continue`.
- **Sorting severity as words.** Wrong: sorting `CRIT`, `INFO`, `WARN` alphabetically puts INFO between them. Right: sort on a numeric rank.
