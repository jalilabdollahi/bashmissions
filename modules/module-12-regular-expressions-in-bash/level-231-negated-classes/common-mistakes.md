# Common Mistakes

- **Using `.*` between delimiters.**
  Wrong: `msg="(.*)"` returns `disk is 91% full" host="halibut` on a line with later
  quotes.
  Right: `msg="([^"]*)"`.
- **Looking for `.*?`.** It is not part of POSIX ERE. In Bash it is an error or
  silently means "zero or one of the previous"; always use a negated class.
- **Putting the caret in the wrong place.** `[a^"]` is the set `a ^ "` and negates
  nothing. The `^` must be the very first character after `[`.
- **Forgetting that `*` allows empty.** `msg=""` captures an empty string. If an empty
  text should count as missing, use `([^"]+)`.
- **Excluding the wrong character.** For a field ending at a space, the class is
  `[^ ]`; for a CSV field `[^,]`. The excluded character is the delimiter that
  ends the text.
