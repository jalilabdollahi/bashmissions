# Common Mistakes

- **Passing the file name to `wc`.** The name is part of the output and breaks arithmetic.
  - Wrong: `lines=$(wc -l "$f")` gives `3 notes.txt`
  - Right: `lines=$(( $(wc -l < "$f") ))`
- **Comparing padded output as text.** On macOS `wc` prints leading spaces.
  - Wrong: `[[ $(wc -l < "$f") == 0 ]]`
  - Right: `(( $(wc -l < "$f") == 0 ))` or `[[ $(( $(wc -l < "$f") )) == 0 ]]`
- **Trusting `-l` for "number of records".** A last line without newline is not counted.
  - Wrong: assuming `printf 'a\nb' | wc -l` is 2 (it is 1)
  - Right: know your input ends with a newline, or add one when you write it
- **Leaving out the quotes around the file.** A name with spaces becomes two arguments.
  - Wrong: `wc -l < $f`
  - Right: `wc -l < "$f"`
