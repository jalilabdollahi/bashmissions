# Common Mistakes

- **Comparing the words.** Wrong: `[[ $level > $threshold ]]` compares alphabetically, so WARN is "greater" than INFO and ERROR is "less" than WARN. Right: compare the numbers, `(( rank[$level] <= rank[$threshold] ))`.
- **Getting the direction backwards.** Symptom: LOG_LEVEL=ERROR prints DEBUG lines and nothing else. Smaller numbers are more important, so a line passes when its rank is *less than or equal to* the threshold's.
- **Forgetting `declare -A`.** Wrong: `rank=([ERROR]=1 ...)` makes an ordinary array where every key is index 0. Right: `declare -A rank=(...)` first.
- **Unknown key under `set -u`.** Wrong: `[[ -z ${rank[$level]} ]]` aborts the script with "unbound variable" on a bad line. Right: `${rank[$level]:-}` gives an empty default.
- **Trimming the line.** Wrong: `read line` without `IFS=` and `-r` strips spaces and eats backslashes, so the printed line differs from the input. Right: `IFS= read -r line`.
