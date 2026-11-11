# Common Mistakes

- **Passing the epoch as text with junk.** Wrong: `printf '%(%H:%M)T\n' 17723x9200` gives a Bash error instead of your friendly usage message. Right: validate that WHEN is all digits (`[[ $when =~ ^[0-9]+$ ]]`) before you hand it over.
- **Putting the format in the wrong place.** Wrong: `printf '%T(%H)' ...`. Right: the pattern is `%(` format `)T`, with the strftime letters inside the parentheses.
- **Local time instead of UTC.** Wrong: stamping `Z` on a time that is really local, so two servers disagree by hours. Right: make sure TZ is UTC (or set `TZ=UTC` for the script) when you write the `Z`.
- **Using `$@` for the message.** Wrong: `printf '... %s\n' "$when" "$@"` prints a *new line per word* of the message. Right: `"$*"` joins the words into one string.
- **Forgetting `shift`.** Wrong: the epoch ends up inside the message, `1772359200 snapshot finished`. Right: `shift` it off after saving it in a variable.
