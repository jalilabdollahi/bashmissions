# Common Mistakes for Replace in String

- Single slash vs. double: `${var/x/y}` replaces only the **first** `x`. To replace all, use `${var//x/y}`.

- Treating `old` as a regex. `${var//*/-}` doesn't replace "any character" — `*` matches the whole string in glob terms. To match any single character, use `?`.

- Forgetting to escape special glob characters. To replace literal `*`, write `${var//\*/x}` (escape the asterisk).

- Putting a space accidentally: `${var// / -}` replaces a single space with `space-dash`, not `dash`. The replacement is everything between the second `/` and the closing `}`.

- Trying to use `sed`-style flags: `${var//x/y/g}` is invalid — there's no `g` flag because `//` already means "all".
