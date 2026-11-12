# Common Mistakes

- **Printing associative array keys in their natural order.** Wrong: `for key in "${!value[@]}"` gives a different order from run to run. Right: `printf '%s\n' "${!value[@]}" | sort`.
- **Parsing `env` output to find `LF_*`.** Wrong: `env | grep '^LF_'` splits values that contain newlines and picks up `LF_` text inside other values. Right: `compgen -v LF_` returns names only.
- **Matching the prefix loosely.** Wrong: `grep LF_` also finds `SELF_PORT` and `LFX_PORT`. Right: anchor it: `^LF_[A-Z0-9_]+$`.
- **Updating the value but not the source.** Wrong: the file layer sets `value[$key]` and forgets `source[$key]`, so the table claims `default` for a value from the file. Right: always assign the pair together.
- **Hard-coding the column width.** Wrong: `%-10s` breaks the alignment when a name is longer. Right: compute the longest name and use `%-*s`.
