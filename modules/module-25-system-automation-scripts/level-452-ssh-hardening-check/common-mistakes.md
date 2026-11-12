# Common Mistakes

- **Letting the last value win.** A loop that assigns `seen[$key]=$value` every time ends with `PermitRootLogin no` from the bottom of the file, while sshd uses the `yes` near the top.
  - Right: skip keys that are already stored.
- **Reading past `Match`.** `PasswordAuthentication yes` inside `Match User backup` is not global; counting it flags innocent files, and counting a good one hides real problems.
  - Right: `break` at the first `Match` line.
- **Case-sensitive comparison.** `PermitRootLogin No` is perfectly valid and equals `no`.
  - Right: lowercase keys and values before comparing.
- **Forgetting `Key=value`.** Splitting only on spaces turns `PermitRootLogin=no` into one word.
  - Right: replace `=` with a space before `read`.
- **Treating "not set" as "fine".** A missing `PasswordAuthentication` means `yes`, not `no`.
  - Right: use the documented default and say so in the output.
