# Common Mistakes

- **Help text written by hand.** Wrong: a separate `echo` block per command, which drifts from the parser. Right: print help from the same registry the parser reads.
- **Relying on the order of an associative array.** Wrong: `for c in "${!desc[@]}"` lists commands in hash order. Right: keep an ordinary array `cmds=(...)` for the order.
- **Only accepting `--opt value`.** Wrong: `--role=pilot` is read as an unknown option. Right: split on `=` first, and fall back to the next argument.
- **Forgetting `--`.** Wrong: a name that begins with a dash is parsed as an option forever. Right: after `--`, everything is positional.
- **One exit code for everything.** Wrong: `exit 1` for a typo and for a missing record. Right: 64 for usage errors, 1 for runtime failures.
- **Letting `set -e` hide the hint.** Wrong: `[[ ... ]] && printf ...` as the last command of a function returns 1 when nothing matches and kills the script. Right: use `if` and `return 0`.
