# Common Mistakes

- **Colon in the wrong place.** `getopts "h:p:q:"` is not silent mode; the colon
  that matters is the very first character: `getopts ":h:p:q"`.
- **Unescaped question mark.** In `case`, `?) ...` matches any single character,
  so it swallows every option. Write `\?)`.
- **Reading `$opt` instead of `$OPTARG` in the error branches.** `$opt` is just
  `?` or `:`. The offending letter is in `$OPTARG`.
- **Expecting getopts to enforce required options.** It cannot know `-h` is
  mandatory. After the loop, check `[[ -z $host ]]` yourself.
- **Leaving out the case branches in silent mode.** With the leading colon and no
  `\?)` or `:)`, mistakes pass silently and the script carries on with defaults.
