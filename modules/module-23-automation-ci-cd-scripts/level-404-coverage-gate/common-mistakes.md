# Common Mistakes

- **Dividing before multiplying.** Wrong: `pct=$(( covered / total * 100 ))` gives 0 for anything below full coverage. Right: `$(( covered * 100 / total ))`, or scale by 1000 for one decimal.
- **Gating on the rounded number.** Wrong: comparing the 80.0 you print against 80, which passes 79.96%. Right: `(( covered * 100 >= threshold * total ))` on the exact values.
- **Skipping validation.** Wrong: `$(( threshold > 100 ))` with `threshold=high` quietly evaluates to false. Right: `[[ $threshold =~ ^[0-9]+$ ]]` first.
- **Octal surprises.** Wrong: `$(( 08 + 1 ))` is an error, because a leading zero means octal. Right: `$(( 10#08 + 1 ))`.
- **Dividing by zero.** Wrong: a report with only empty files crashes with "division by 0". Right: check `sum_tot == 0` and report `no measurable lines`.
