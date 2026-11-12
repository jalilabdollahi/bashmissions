# Common Mistakes

- **Writing only half of the second comparison.** Each side of `&&` must be a complete test.
  - Wrong: `[[ $group == staff && yes ]]` ("yes" alone is a non-empty string, so it is always true)
  - Right: `[[ $group == staff && $mfa == yes ]]`
- **Using `-a` or `&` instead of `&&`.** A single `&` runs the first command in the background.
  - Wrong: `[[ $group == staff & $mfa == yes ]]`
  - Right: `[[ $group == staff && $mfa == yes ]]`
- **Putting `&&` outside the brackets but inside a single-bracket test.** `[ ]` does not understand `&&` inside it.
  - Wrong: `[ "$group" = staff && "$mfa" = yes ]`
  - Right: `[[ $group == staff && $mfa == yes ]]`
- **Forgetting that every other combination is "denied".** Do not write three separate elif branches for the failures; one `else` handles them all.
  - Wrong: three `elif` branches that each print `denied`
  - Right: one `else` that prints `denied`
