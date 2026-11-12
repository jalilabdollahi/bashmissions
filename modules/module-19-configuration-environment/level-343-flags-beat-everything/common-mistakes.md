# Common Mistakes

- **Reading `$2` when there is no `$2`.** Wrong: `--retention) ret=$2; shift 2` as the last argument crashes with `unbound variable`. Right: test `(( $# >= 2 ))` first and print `missing value for --retention`.
- **Supporting only one spelling.** Wrong: `--dest) ...` alone makes `--dest=/mnt/x` an "unknown option". Right: add `--dest=*)` with `${1#*=}`.
- **Forgetting `shift` (or shifting once for a pair).** Wrong: `--dest) dest=$2; shift` leaves the path in `$@`, where it is reported as an unexpected argument. Right: `shift 2` for option plus value.
- **Letting the file win by reading it last.** Wrong: `[[ -r $config ]] && dest=$(...)` after the flag was stored overwrites it. Right: keep layers apart and test flag first.
- **Treating `--compress` as a value option.** Wrong: it swallows the next argument. Right: `--compress) flag[compress]=yes; shift`.
