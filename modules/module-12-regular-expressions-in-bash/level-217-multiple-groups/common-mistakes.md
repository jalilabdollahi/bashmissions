# Common Mistakes

- Quoting the regex on the right side of `[[ string =~ regex ]]`, which makes Bash treat it more literally.
- Reading `BASH_REMATCH` before checking that the match succeeded.
- Forgetting anchors when the whole input must match.
