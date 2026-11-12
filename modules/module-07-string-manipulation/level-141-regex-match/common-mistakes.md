# Common Mistakes

- **No anchors.** `[[ $tag =~ [0-9]+\.[0-9]+\.[0-9]+ ]]` accepts `1.4.2-rc1` and
  `release-1.4.2` because it matches inside them. Add `^` and `$`.
- **An unescaped dot.** In `[0-9]+.[0-9]+` the dot means any character, so `1a4`
  passes. Write `\.` for a literal dot.
- **Quoting the regex.** `[[ $tag =~ "^v?[0-9]+$" ]]` compares literal text and
  never matches. Keep the regex unquoted, or in a variable: `[[ $tag =~ $re ]]`.
- **Using glob thinking.** In a regex `*` means "repeat the previous item", not
  "anything". `v*1` is a v repeated any number of times, then a 1.
