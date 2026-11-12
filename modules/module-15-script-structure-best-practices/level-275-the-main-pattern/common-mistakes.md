# Common Mistakes

- **Forgetting to call main.** Wrong: define `main() { ... }` and stop; the script does nothing and exits 0. Right: the last line is `main "$@"`.
- **Dropping the arguments.** Wrong: `main` with no arguments makes `$1` empty inside the function. Right: `main "$@"`.
- **Unquoted `$@`.** Wrong: `main $@` splits `Harbour Bakery.txt` into two files. Right: `main "$@"`.
- **Using `exit` deep inside helpers.** Wrong: `exit 2` in a function you may want to reuse or test later. Prefer `return 2` and let the status travel up to the script's last line.
- **Code after the call.** Wrong: a line below `main "$@"` runs after the program and replaces its exit status. Right: nothing follows the call.
