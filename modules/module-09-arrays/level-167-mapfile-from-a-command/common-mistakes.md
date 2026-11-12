# Common Mistakes

- **Piping into `mapfile`.** `find . -name '*.conf' | mapfile -t confs` leaves `confs` empty afterwards, because the right-hand side ran in a subshell.
  Right: `mapfile -t confs < <(find . -name '*.conf')`
- **Writing `<(...)` without the redirect.** `mapfile -t confs <(find ...)` passes the name as an argument and fails. You need both: `< <(...)`.
- **Using `$(...)` in an array assignment.** `confs=($(find ...))` splits at spaces, so "old pier.conf" becomes two elements.
- **Forgetting `sort`.** `find` lists files in directory order, which differs between machines and runs. Tests and audits need a fixed order.
- **Forgetting `-maxdepth 1`.** Without it `find` descends into subdirectories and counts files you did not ask for.
