# Common Mistakes

- **Reading a zero-padded decimal as octal.**
  - Wrong: `$(( 08 ))` fails with "value too great for base"
  - Right: `$(( 10#08 ))` is 8
- **Using `%d` and expecting another base.** `%d` is always decimal.
  - Wrong: `printf '%d' "$port"` to show hex
  - Right: `printf '%x' "$port"`
- **Forgetting the base in front of letters.**
  - Wrong: `$(( 1f90 ))` is a syntax error ("value too great for base")
  - Right: `$(( 16#1f90 ))`
- **Expecting `echo` to convert.** It prints whatever text it was given.
  - Wrong: `echo $(( 16#ff ))` is decimal 255, and `echo ff` is just the letters ff
  - Right: convert on the way in with `16#`, and on the way out with `printf %x`
