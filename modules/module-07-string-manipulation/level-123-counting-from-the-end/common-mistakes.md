# Common Mistakes

- **Dropping the space.** `${key:-4}` is not a negative offset. It prints the
  whole key (or `4` when the key is empty). Right: `${key: -4}`.
- **Off by one from the end.** `${key: -1}` is the last character, so the last
  four need `-4`, not `-3`.
- **Slicing short strings.** `${s: -4}` on `xyz` returns an empty string, not
  `xyz`. Check `${#s}` first when the input may be short.
- **Printing the mask on the error path.** The error text goes to stderr
  (`>&2`); if it lands on stdout, a script that captures the output gets the
  complaint instead of a key.
