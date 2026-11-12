# Common Mistakes

- **Quoting the pattern.** Quotes make the wildcard a literal star.
  - Wrong: `[[ $name == "*.log" ]]` (only matches a file literally named `*.log`)
  - Right: `[[ $name == *.log ]]`
- **Using regex syntax instead of globs.** In a glob, `.` is a plain dot and `.*` means "dot, then anything".
  - Wrong: `[[ $name == .*\.log ]]` or `[[ $name == ^tmp ]]`
  - Right: `[[ $name == *.log ]]`
- **Using `*` where exactly one character is meant.** `crash-*.dump` also accepts `crash-12.dump`.
  - Wrong: `[[ $name == crash-*.dump ]]`
  - Right: `[[ $name == crash-?.dump ]]`
- **Expecting a partial match.** The pattern must cover the whole string.
  - Wrong: `[[ $name == .log ]]` expecting "contains .log"
  - Right: `[[ $name == *.log* ]]`
