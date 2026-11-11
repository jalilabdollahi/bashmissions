# Common Mistakes

- **Using `:-` and expecting it to stick.**
  Wrong: `: "${REGION:-north-pier}"` then `echo "$REGION"` prints an empty line.
  Right: `: "${REGION:=north-pier}"`.
- **Leaving out the `:` command.**
  Wrong: `"${REGION:=north-pier}"` on its own line - Bash tries to run the value as a command: `north-pier: command not found`.
  Right: `: "${REGION:=north-pier}"`.
- **Writing the assignment twice.**
  Wrong: `REGION=north-pier` followed by the `:=` line silently overwrites whatever the caller passed.
  Right: only the `:=` line decides.
- **Using it on a special parameter.** `${1:=x}` fails with `cannot assign in this way`. Positional arguments arrive in module 3 with other tools.
