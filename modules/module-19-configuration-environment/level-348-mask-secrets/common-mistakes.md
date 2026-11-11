# Common Mistakes

- **Case-sensitive matching.** Wrong: `case $name in *_TOKEN)` lets `stripe_token=...` through in clear. Right: `case ${name^^} in`.
- **Writing `${value:-4}` for the tail.** Wrong: it means "value, or 4 if empty" and prints the whole secret. Right: `${value: -4}` with a space.
- **Revealing too much of short secrets.** Wrong: `****${value: -4}` on `hunter2` shows `ter2`, four of its seven characters. Right: only show a tail when `${#value} >= 12`.
- **Ignoring URLs.** Wrong: `DATABASE_URL` does not end in a secret suffix, so `postgres://bakery:s3cr=t@db` prints in full. Right: also mask the password part of any value containing `://user:pass@`.
- **Matching `*KEY` without the underscore.** Wrong: it masks `MONKEY` and `KEYBOARD` too, hiding harmless data and teaching people to ignore the masks. Right: `*_KEY`.
