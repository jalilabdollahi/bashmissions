# Common Mistakes

- **Unescaped dots.** `^v([0-9]+).([0-9]+).([0-9]+)$` also accepts `v1x2x3`,
  because `.` means any character. Use `\.`.
- **Counting the wrong parenthesis.** In `^v(([0-9]+)\.([0-9]+))$` group 1 is the
  *whole* "major.minor" part and the major number is group 2. Count the opening
  brackets from the left.
- **Reading groups after a failed match.** The `else` branch must not use
  `BASH_REMATCH`; for `oops` it would still hold the numbers of `v3.1.4`.
- **Missing anchors.** `v([0-9]+)\.([0-9]+)\.([0-9]+)` accepts `v2.14.3.4` and
  `xv2.14.3`, because the good part is found inside.
- **Forgetting that the whole match is element 0.** Printing `${BASH_REMATCH[@]}`
  shows the whole tag *and* the three numbers; ask for the indexes you mean.
