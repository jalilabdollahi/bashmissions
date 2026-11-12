# Common Mistakes

- **Matching the bare word instead of the quoted key.** `sed -nE 's/.*id: *...'` or a pattern without the quotes finds `customer_id` too.
  - Right: include the quotes, `"id"`, in the pattern.
- **Forgetting the optional space.** `"plan":"` fails on pretty-printed replies that contain `"plan": "`.
  - Right: `": *"?`
- **Capturing too much.** `(.*)` runs to the end of the line and returns `pro","balance":42.5,...`.
  - Right: stop at the delimiters: `([^",}]*)`
- **Printing the whole line when nothing matched.** Plain `sed 's/.../\1/'` (without `-n` and `p`) prints the unchanged JSON for a missing field.
  - Right: `sed -nE 's/.../\1/p'` and test for an empty result.
- **Shell variable inside single quotes.** `'s/.*"$field":.../'` searches for the literal `$field`.
  - Right: close the quotes around it, `'...'"$field"'...'`
