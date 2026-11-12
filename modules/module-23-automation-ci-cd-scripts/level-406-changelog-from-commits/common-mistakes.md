# Common Mistakes

- **Printing while reading.** Wrong: echoing a heading the first time you see a `feat`, which scrambles the section order. Right: collect into arrays and print the sections after the loop.
- **Matching the type loosely.** Wrong: `[[ $subject == *fix* ]]` files `prefix: add a postfix` under Fixes. Right: capture the type with an anchored regex and compare `$type == fix`.
- **Losing the bang.** Wrong: handling `feat!:` as an ordinary feature because `type` is `feat`. Right: test `[[ -n $bang ]]` first.
- **Empty array under `set -u`.** Wrong: `printf '%s\n' "${fixes[@]}"` with no fixes can abort with "unbound variable" on older Bash. Right: `"${fixes[@]+"${fixes[@]}"}"`, or check the length first.
- **Dropping unconventional subjects.** Wrong: `continue` when the regex does not match, silently hiding commits. Right: put them in Other.
