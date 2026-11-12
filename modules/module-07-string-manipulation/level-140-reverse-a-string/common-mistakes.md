# Common Mistakes

- **Starting at the length.** `i = ${#token}` points one past the last character
  (positions end at length-1), so the first step appends an empty string, and
  you may think the last character is missing from the output.
- **Stopping at 1.** `i > 0` skips position 0, the first character, which
  becomes the missing last character of the result. Use `i >= 0`.
- **Prepending in the wrong direction.** Counting up and doing `decoded+=${token:i:1}`
  copies the string unchanged. Either count down and append, or count up and
  prepend (`decoded=${token:i:1}$decoded`).
- **Looping over words instead of characters.** `for c in $token` splits at
  whitespace, not between letters. Characters need an index and `${token:i:1}`.
