# Common Mistakes

- **Using `command -v` for functions.** Wrong: `command -v "check_$name"` is also true for programs on the PATH (the test has a `check_pier` program) and then the external program runs. Right: `declare -F "check_$name"`.
- **Testing the variable instead.** Wrong: `[[ -n ${check_backup:-} ]]` or `[[ -v check_backup ]]` asks about variables, and an environment variable of that name makes it say yes. Right: `declare -F`.
- **Letting `declare -F` print.** Wrong: `if declare -F "check_$name"; then` prints `check_disk` into your output. Right: `> /dev/null` and keep the status.
- **Using lowercase `-f` as a test.** `declare -f name` prints the whole body when the function exists, flooding the output, though its status is also usable. Reach for `-F` when you only want to know whether it exists.
- **Aborting on the first typo.** Wrong: calling `"check_$name"` directly makes bash exit with status 127 mid-run under `set -e`. Right: check, report, continue.
