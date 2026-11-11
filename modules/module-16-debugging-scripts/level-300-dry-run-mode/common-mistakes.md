# Common Mistakes

- **Running the command in dry-run mode too.** Wrong: printing and then falling through to `"$@"`. Right: `if ... print ... else "$@" fi`. The proof is that the three files and folders must not exist afterwards.
- **Quoting `"$*"` instead of `"$@"`.** `run "$*"` passes the whole command as one word, which Bash then tries to find as a program name. Use `"$@"`, which keeps each argument separate.
- **Using `echo` for the preview.** `echo would run: $@` hides word boundaries, so `Tidewater Books` looks like two names. Use `printf ' %q'`.
- **Forgetting `shift` after the flag.** Wrong: `$1` is still `--dry-run`, so the site becomes `--dry-run`. Right: `shift` once the flag is consumed.
- **Leaving one command outside `run`.** A bare `chmod` in the script ignores the flag and changes the system during a dry run. Every command that changes something goes through `run`.
