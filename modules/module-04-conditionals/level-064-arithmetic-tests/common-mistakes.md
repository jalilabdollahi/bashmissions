# Common Mistakes

- **Putting a `$` in front of the test.** `$(( ))` produces a value; as a command you want plain `(( ))`.
  - Wrong: `if $(( used > quota )); then` (tries to run the result "1" as a command)
  - Right: `if (( used > quota )); then`
- **Using `>` inside `[[ ]]` expecting numbers.** That compares text.
  - Wrong: `if [[ $used > $quota ]]` (9 beats 100)
  - Right: `if (( used > quota ))`
- **Mixing up `=` and `==`.** A single `=` inside `(( ))` assigns a value and is almost always true.
  - Wrong: `if (( used = quota ))`
  - Right: `if (( used == quota ))`
- **Expecting decimals.** `(( ))` works with integers only; `(( 2.5 > 1 ))` is a syntax error.
  - Wrong: passing `2.5` as the quota
  - Right: use whole numbers (convert to MB, for example)
