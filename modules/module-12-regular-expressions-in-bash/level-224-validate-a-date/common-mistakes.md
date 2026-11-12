# Common Mistakes

- **Octal surprises.** `(( ${BASH_REMATCH[2]} > 12 ))` with `08` ends in "value too
  great for base". Use `10#${BASH_REMATCH[2]}`.
- **Validating only the format.** `^[0-9]{4}-[0-9]{2}-[0-9]{2}$` is happy with
  `2024-99-99`. A date regex is only step one.
- **A February of 28 days only.** `2024-02-29` is real. Do the leap-year test:
  `year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)`.
- **Forgetting day zero.** `2024-06-00` passes `day <= 30`. Check `day < 1` too.
- **Reading the groups after a second match.** Any later `[[ =~ ]]` overwrites
  `BASH_REMATCH`. Copy the three numbers into variables first.
