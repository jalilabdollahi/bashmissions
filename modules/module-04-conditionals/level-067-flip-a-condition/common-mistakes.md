# Common Mistakes

- **Searching without `-x`.** A shorter address matches inside a longer one and slips through.
  - Wrong: `if ! grep -q "$ip" allowlist.txt` (10.0.0.1 is found inside 10.0.0.15)
  - Right: `if ! grep -qx "$ip" allowlist.txt`
- **Forgetting `-F` when the text contains dots.** In a regex, `.` matches any character, so `10x1x0x1` matches `10.1.0.1`.
  - Wrong: `grep -qx "$ip" allowlist.txt`
  - Right: `grep -qxF "$ip" allowlist.txt`
- **Putting `!` without a space.** Bash then looks for a command called `!grep`.
  - Wrong: `if !grep -qxF "$ip" allowlist.txt; then`
  - Right: `if ! grep -qxF "$ip" allowlist.txt; then`
- **Double negatives.** `if ! ... else` with the interesting code under `else` is hard to read. Put the case you care about under `then`.
  - Wrong: `if ! grep -q ...; then :; else echo BLOCK; fi`
  - Right: `if ! grep -q ...; then echo BLOCK; fi`
