# Common Mistakes

- **Trusting the file.** Wrong: `[[ -e $pidfile ]] && echo running`. The file's existence says nothing about the process. Always ask the system.
- **Checking only that the pid exists.** Wrong: `ps -p "$pid" >/dev/null && echo running` calls a recycled PID healthy. Right: also compare the name, `[[ $actual == "$name" ]]`.
- **Letting `set -e` kill the script.** Wrong: `actual=$(ps -p "$pid" -o comm=)` aborts silently for a dead process. Right: `... || true`, then test `-z "$actual"`.
- **Using the content unchecked.** Wrong: `ps -p $(cat file)` with a file that holds `4242 -o args` or an empty line. Right: validate with `[[ $pid =~ ^[0-9]+$ ]]` and quote it.
- **Leaving the stale file behind.** Symptom: the next start-up script reads the same lie and refuses to launch. Remove it with `rm -f` once you are sure it is stale.
