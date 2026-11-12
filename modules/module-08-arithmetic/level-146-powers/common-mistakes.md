# Common Mistakes

- **Forgetting parentheses around the exponent.** `**` is stronger than `-`.
  - Wrong: `$(( 2 ** 32 - prefix ))` gives 4294967272 for /24
  - Right: `$(( 2 ** (32 - prefix) ))`
- **Using `^`.** In Bash that is bitwise XOR, not a power.
  - Wrong: `$(( 2 ^ 8 ))` gives 10
  - Right: `$(( 2 ** 8 ))` gives 256
- **Writing `2**8` inside quotes outside arithmetic.** Without `$(( ))` it is just text, and unquoted `**` may be expanded as a file glob.
  - Wrong: `echo 2 ** 8` prints a file list or the literal text
  - Right: `echo $(( 2 ** 8 ))`
- **Expecting a fractional result.** A negative exponent is an error: `$(( 2 ** -1 ))` fails with "exponent less than 0".
