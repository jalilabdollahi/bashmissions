# Common Mistakes

- **Leaving out the colon.** `${2-22}` only uses 22 when `$2` is *unset*; a
  passed empty string `""` stays empty and prints `on port `. Right: `${2:-22}`.
- **Reading `$2` with `set -u` and no default.** `port=$2` aborts with
  `$2: unbound variable` when the caller omits it. Right: `port=${2:-22}`.
- **Mixing up the separators.** `${2:22}` is a substring operation, and
  `${2=22}` is not allowed for positional parameters. The pair that works is
  colon and dash together.
- **Quoting the default wrongly.** `${2:-"22"}` works, but `${2:-$default value}`
  with spaces needs quotes around the whole expansion where you use it.
