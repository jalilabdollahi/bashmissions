# Common Mistakes

- **Forgetting `shift` after `getopts`.** `$1` is still `-f`, and your script tries to treat that as the hosts folder.
  - Right: `shift $(( OPTIND - 1 ))` after the loop.
- **Missing colon in the option string.** `getopts "fm"` makes `-m` a flag and `OPTARG` stays empty.
  - Right: `getopts "fm:"` for an option that takes a value.
- **Comparing `91%` as text.** `[[ $cap > 90 ]]` is a string comparison, and `91%` is not even a number.
  - Right: in awk `($5 + 0) >= 90`, or strip the `%` first and use `(( ))`.
- **Using the last `PermitRootLogin` line, or a case-sensitive match.** sshd takes the first, and `permitrootlogin NO` is legal.
  - Right: lowercase, take the first match, then compare.
- **Rounding the percentage up.** 11 of 12 checks is 91%, and a requirement of 92% must fail.
  - Right: integer division `passed * 100 / total`.
