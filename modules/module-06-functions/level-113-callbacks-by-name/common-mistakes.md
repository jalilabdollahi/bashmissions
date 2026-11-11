# Common Mistakes

- **Calling the name without the dollar sign.** `callback "$item"` runs a command
  literally called `callback`. Right: `"$callback" "$item"`.
- **Forgetting `shift`.** Without it the callback's own name is looped over as if it
  were an item, so `upper_line upper_line` is called first.
- **Passing the call instead of the name.** `apply_each upper_line()` or
  `apply_each "upper_line dory"` hand over text that is not a function name. Pass
  only the name.
- **Shifting with no arguments under `set -e`.** `shift` on an empty argument list
  fails and aborts the script. Check `$#` first.
- **Trusting user input as the callback.** `apply_each "$1" ...` would run any
  command the user typed. Map the mode through `case` instead.
