# Common Mistakes

- **Expecting the default to be stored.**
  Wrong: using `${LOG_LEVEL:-info}` once and then printing `$LOG_LEVEL` later - it is still empty.
  Right: the next level, `${LOG_LEVEL:=info}`, assigns as well.
- **Writing the default without the colon-dash pair.**
  Wrong: `${LOG_LEVEL:info}` means something else entirely (a substring) and prints nonsense.
  Right: `${LOG_LEVEL:-info}`.
- **Putting the default outside the braces.**
  Wrong: `"$LOG_LEVEL:-info"` prints the value, then the literal text `:-info`.
  Right: `"${LOG_LEVEL:-info}"`.
- **Reaching for if/else for every setting.** It works, but a three-setting script becomes a dozen lines of ceremony.
