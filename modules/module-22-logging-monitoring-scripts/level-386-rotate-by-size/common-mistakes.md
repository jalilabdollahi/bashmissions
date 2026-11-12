# Common Mistakes

- **Shifting upward from 1.** Wrong: `for i in 1 2 3; do mv log.$i log.$((i+1)); done` moves `.1` onto `.2`, then that same file onto `.3`: every copy ends up as one. Right: count down from KEEP-1 to 1.
- **Measuring with a file name in the output.** Wrong: `size=$(wc -c "$log")` gives `10 shop.log`, and the comparison fails or errors. Right: `wc -c < "$log"`.
- **Trusting the padded number.** Symptom: on macOS `[[ $size == 10 ]]` fails because the value is `      10`. Wrap with `$(( ... ))` or use `tr -d ' '`.
- **Rotating at exactly the limit.** Wrong: `size < max` rotates a file that is 'full' but allowed, and `size >= max` fires one byte early. The spec says rotate only when size is *greater than* MAXBYTES.
- **Forgetting the new empty log.** Symptom: after rotation the service cannot find its log (or recreates it with the wrong permissions). End with `: > "$log"`.
