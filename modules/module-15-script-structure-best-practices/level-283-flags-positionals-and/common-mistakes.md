# Common Mistakes

- **Reading `$2` without checking it exists.** Wrong: `-p) prefix=$2; shift 2` when `-p` was the last argument; `set -u` dies with "unbound variable" and `shift 2` fails. Right: test `[ "$#" -lt 2 ]` first and report a clear error.
- **Forgetting to shift.** Wrong: a branch without `shift` loops forever on the same argument. Right: every branch shifts (or breaks).
- **Putting `-*)` before the specific options.** Wrong: it swallows `-u`. Right: `-u|--upper)` first, `-*)` after.
- **No `--` branch.** Wrong: `solution.sh -u -- -n` reports "unknown option: --", and a word like `-n` can never be passed. Right: `--) shift; break ;;`.
- **Shifting the first word away.** Wrong: `*) shift ;;` in the loop eats the positionals. Right: `*) break ;;` leaves it in place.
