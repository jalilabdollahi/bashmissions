# Common Mistakes

- **Forgetting the `&` when writing.** You create a file named `3`.
  - Wrong: `echo "$service: $state" >3`
  - Right: `echo "$service: $state" >&3`
- **Opening with `>` inside the loop.** Each iteration truncates the file; only the last line survives.
  - Wrong: `echo "$service: $state" > report.txt`
  - Right: `exec 3> report.txt` before the loop and `>&3` inside
- **Writing before opening.** Bash reports "3: Bad file descriptor".
  - Wrong: `echo hi >&3` before `exec 3> report.txt`
  - Right: open first
- **Using `exec` without a redirection by accident.** `exec cmd` REPLACES the shell with the command.
  - Wrong: `exec svc-status nginx` (the script ends there)
  - Right: `exec 3> report.txt` (no command, only a redirection)
