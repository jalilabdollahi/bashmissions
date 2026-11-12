# Common Mistakes

- **Comparing or incrementing as text.** Wrong: `patch=${patch}1` or sorting `1.10.0` below `1.9.0` as strings. Right: store each part as an integer and use `$(( patch + 1 ))`.
- **Forgetting to reset.** Wrong: bumping minor of `1.4.7` to `1.5.7`. Right: `minor=$(( minor + 1 )); patch=0`.
- **A loose pattern.** Wrong: `[[ $v =~ [0-9.]+ ]]` accepts `1.2`, `..` and `1.2.3.4` (it is not anchored). Right: an anchored regex with exactly three numbers.
- **Quoting the regex variable.** Wrong: `[[ $v =~ "$re" ]]` makes it a literal string match. Right: `[[ $v =~ $re ]]`.
- **Octal accidents.** Wrong: allowing `08` and then `$(( 08 + 1 ))`, which fails with "value too great for base". Right: reject leading zeros in the regex, or use `10#`.
