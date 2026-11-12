# Common Mistakes

- **No spaces inside the brackets.** Bash reads `[[$target==prod]]` as one strange command name.
  - Wrong: `if [[$target == prod]]; then`
  - Right: `if [[ $target == prod ]]; then`
- **Forgetting `fi`.** The error appears at the end of the file ("unexpected end of file"), far from the real mistake.
  - Wrong: `if [[ $target == prod ]]; then echo hi`
  - Right: `if [[ $target == prod ]]; then echo hi; fi`
- **Using a single `=` as if it were assignment.** In a test, `==` compares. Write the comparison, never `target=prod` inside the brackets.
  - Wrong: `if [[ $target = prod ]]` is accepted but looks like assignment to readers; prefer `==`.
- **Forgetting `then`.** The test line alone is not enough.
  - Wrong: `if [[ $target == prod ]]` followed directly by `echo`
  - Right: add `; then` after the test, or put `then` on the next line.
