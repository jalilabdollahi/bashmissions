# Common Mistakes

- **Too few variable names.** `read -r host address` puts the whole rest of the
  line, `10.0.0.5 database`, into `address`. Name one variable for every field you
  want, and let the last one be the leftover.
- **Assuming each variable gets exactly one word.** `read -r a b c` on
  `x y z w` gives `c="z w"`, not `c=z`.
- **Treating a missing field as an error.** `read -r a b c` on `x y` succeeds with
  `c=""`. Under `set -u` an empty value is fine, but an *unset* name is not.
- **Splitting twice.** `read -r line` followed by `echo $line | cut ...` runs an
  extra process to do what `read -r a b c` does in one step.
