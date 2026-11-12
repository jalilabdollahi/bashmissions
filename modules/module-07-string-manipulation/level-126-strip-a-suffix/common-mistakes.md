# Common Mistakes

- **Using `%%` for "last extension".** `${file%%.*}` removes from the FIRST dot:
  `archive.tar.gz` becomes `archive`. Single `%` for the last one.
- **Mixing up `#` and `%`.** `${file#.*}` tries to trim the front and does nothing
  to `db.sql.gz`. Suffixes need `%`.
- **Writing a regex.** `${file%\.[a-z]*$}` is not how patterns work: no `$`
  anchor is needed, because `%` already works from the end.
- **Hidden files.** `${f%.*}` on `.bashrc` yields an empty string, since the
  whole name matches `.*`. Check for a leading dot if hidden files can appear.
