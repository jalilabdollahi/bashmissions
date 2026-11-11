# Common Mistakes

- **Taking the extension from the whole path.** A dot in a folder name leaks in.
  - Wrong: `ext=${path##*.}` for `v1.2/readme` gives `2/readme`
  - Right: `name=${path##*/}` first, then `ext=${name##*.}`
- **Forgetting that "no dot" returns the whole name.** `Makefile` would be counted as an extension called `Makefile`.
  - Wrong: `ext=${name##*.}` with no further test
  - Right: `[[ $name == *.* ]]` before trusting it
- **Counting in a piped loop.** The counters live in a subshell and are empty afterwards.
  - Wrong: `find "$folder" -type f | while read -r p; do ((count[$e]++)); done; echo "${count[@]}"`
  - Right: `while read -r p; do ...; done < <(find "$folder" -type f)`
- **Sorting counts as text.** `10` sorts before `9` without `-n`.
  - Wrong: `sort -k2,2r`
  - Right: `sort -k2,2nr -k1,1`
- **Treating `JPG` and `jpg` as different kinds.** The report splits one kind in two.
  - Wrong: `count[$ext]` with the raw extension
  - Right: `ext=${ext,,}` before counting
