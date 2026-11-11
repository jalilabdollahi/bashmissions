# Common Mistakes

- **Testing the value instead of the key.** `[[ -n ${settings[$key]} ]]` is false for both missing and empty, so you cannot tell them apart.
  Right: `[[ -v settings[$key] ]]`
- **Using `:-` as an existence check.** `${settings[$key]:-(not set)}` prints "(not set)" for a key that is set to an empty string. `:-` treats empty as missing (`-` without the colon would not).
- **Writing the test without the key's brackets.** `[[ -v settings ]]` asks about the whole variable, not about the key.
- **Putting `$` in front of the name.** `[[ -v $settings[$key] ]]` expands the variable first and tests something unrelated. The name goes bare: `-v settings[$key]`.
- **Reading a missing key under `set -u`.** `${settings[$key]}` is an "unbound variable" error. Test with `-v` first.
