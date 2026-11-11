# Common Mistakes

- **Using `source` because it works on the happy path.** Wrong: `set -a; source "$1"; set +a`. It also runs `X=$(touch pwned)`. Right: read lines and `export "$key=$value"`.
- **Splitting on every `=`.** Wrong: `IFS== read -r k v` is fine, but `cut -d= -f2` turns `Open: Mon=Fri` into `Open: Mon`. Right: take everything after the first `=` with the regex group `(.*)`.
- **Evaluating after parsing.** Wrong: `eval "export $key=$value"` brings the injection back through the side door. Right: `export "$key=$value"`, one quoted string.
- **Forgetting `-r` or `IFS=` on `read`.** Wrong: `read line` eats backslashes and trims leading blanks of every value. Right: `IFS= read -r line`.
- **Dropping the last line.** Wrong: `while read -r line` skips a final line with no newline, silently losing a setting. Right: `while IFS= read -r line || [[ -n $line ]]`.
