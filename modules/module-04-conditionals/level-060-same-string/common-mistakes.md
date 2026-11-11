# Common Mistakes

- **Leaving the right-hand side unquoted.** The value is treated as a pattern, so a `*` matches everything.
  - Wrong: `if [[ $running == $expected ]]` (with expected=`*` this says "in sync")
  - Right: `if [[ $running == "$expected" ]]`
- **Writing the comparison without spaces.** `[[ $a==$b ]]` is a single word, which is always true.
  - Wrong: `[[ $running==$expected ]]`
  - Right: `[[ $running == "$expected" ]]`
- **Expecting case to be ignored.** `v2.4.1` and `V2.4.1` are different strings, and that is the point of this audit.
  - Wrong: assuming `[[ V2 == v2 ]]` is true
  - Right: if you ever need to ignore case, lowercase both values first (`${a,,}`)
- **Using `-eq` on text.** `-eq` is for numbers; on a tag like `v2.4.1` it throws an error.
  - Wrong: `[[ $running -eq $expected ]]`
  - Right: `[[ $running == "$expected" ]]`
