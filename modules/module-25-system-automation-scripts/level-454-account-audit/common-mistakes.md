# Common Mistakes

- **Printing findings as you go.** The report then follows file order, not check order, and cannot be diffed or grouped.
  - Right: collect each check's results in its own list and print the lists at the end.
- **Treating an empty hash and a missing entry alike.** `[[ -z ${hash[$name]} ]]` is true for both, and under `set -u` errors for the missing one.
  - Right: test presence with `${hash[$name]+set}` first.
- **Comparing UIDs as text.** `[[ $uid > 999 ]]` is a string comparison.
  - Right: `(( uid >= 1 && uid <= 999 ))`
- **Assuming "UID 0 means root".** The name `toor` with UID 0 is root as far as the kernel is concerned.
  - Right: flag UID 0 under any other name.
- **Counting fields with `awk '{print NF}'` on a colon file.** Without `-F:` there is one field per line, so everything looks malformed.
  - Right: `IFS=:` or `awk -F:` throughout.
