# Common Mistakes

- **Using `$*`.** Wrong: `tracker-cli new --source=cli $*` splits "disk full" into two arguments and expands `*` into file names. Right: `"$@"`.
- **Quoting only the star.** Wrong: `"$*"` merges every argument into one string: `args=3` with a single `[urgent billing]`. Right: `"$@"` keeps them separate.
- **Forwarding `$1` only.** Wrong: `... "$1"` drops the rest, and with no arguments sends an empty word. Right: `"$@"` sends exactly the ones that exist.
- **Forgetting to pass them into the function.** Wrong: calling plain `ticket`; inside a function `$@` is the function's own list, which is empty. Right: `ticket "$@"` at the call site.
- **Putting the fixed words after `"$@"`.** The command line is positional: `tracker-cli new --source=cli "$@"` and `tracker-cli "$@" new --source=cli` are different commands. Put fixed words first when they select the subcommand.
