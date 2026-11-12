# Common Mistakes

- **Counting from 1.** `${stamp:1:4}` starts at the second character and gives
  `0241`, not `2024`. Offsets start at 0.
- **Mixing up length and end position.** The second number is how many characters
  to take, not where to stop: `${stamp:4:2}` is `11`; `${stamp:4:6}` is `1107T0`.
- **Forgetting the `T` in the middle.** The hour starts at 9, not 8. If the time
  prints as `T0`, you are one character early.
- **Using `${stamp[0:4]}` or `$stamp:0:4`.** Without the braces Bash reads
  `$stamp` and then the literal text `:0:4`. Always write `${stamp:0:4}`.
