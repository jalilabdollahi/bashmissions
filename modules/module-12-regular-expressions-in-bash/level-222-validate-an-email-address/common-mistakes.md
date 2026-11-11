# Common Mistakes

- **A dash in the middle of a class.**
  Wrong: `[a-z.-_]` is a range from `.` to `_` (and may even be an error).
  Right: `[a-z._-]`, with the dash last.
- **An unescaped dot before the extension.** `...@[[:alnum:].-]+.[[:alpha:]]{2,}$`
  lets `noor@lanternfishXcom` through. Write `\.`.
- **No anchors.** Without `^...$`, the string `<noor@lanternfish.example>` or
  `x noor@lanternfish.example y` validates, because a valid address is
  found *inside* it.
- **Using `.*` for the parts.** `^.*@.*\..*$` accepts spaces, two `@`, and an empty
  extension. Narrow classes are what make a validator useful.
- **Trusting it too much.** Passing the regex means "looks like an address", not "the
  mailbox exists". Confirm with a real message when it matters.
