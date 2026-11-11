# Common Mistakes

- **Expecting a multi-character separator.** `IFS=", "` glues with just the
  comma: `eel,flounder`, not `eel, flounder`. Only the first character counts.
- **Using `$*` without quotes.** `echo $*` splits again and the glue is lost: it
  prints `eel flounder grouper` whatever IFS is.
- **Using `"$@"` when you wanted one string.** `IFS=,; echo "affected: $@"` still
  prints spaces between words. Only `"$*"` uses IFS to join.
- **Leaving IFS empty by accident.** `IFS=` (nothing) joins with no glue at all:
  `eelflounder`. Put the comma after the equals sign.
