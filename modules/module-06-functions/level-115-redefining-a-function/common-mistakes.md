# Common Mistakes

- **Overriding before sourcing.** Writing your `notify` above `source` means the
  library replaces it, and you get `notice: ...` instead of `[ops-desk] ...`.
- **Redefining `report` as well.** Then you are rewriting the library, not
  customising it. Override the small helpers it calls.
- **Misspelling the name.** `retention_day() { echo 90; }` is a perfectly valid
  *new* function that nobody calls, and the old one keeps running. Compare names
  with `declare -F`.
- **Using `$1` only in `notify`.** Messages may be several words; `$*` or `"$@"`
  carries all of them.
- **Expecting the old version to stay available.** Once replaced, the library's
  `notify` is gone unless you saved a copy under another name first.
