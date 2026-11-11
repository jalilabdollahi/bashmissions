# Common Mistakes

- **Splitting at the wrong equals sign.** Wrong: `${field%=*}` removes only the *last* `=`, so `url=http://x/?a=1` splits badly. Right: `${field%%=*}` for the key and `${field#*=}` for the value cut at the first one.
- **Not escaping quotes in the message.** Wrong: `msg="user typed "root" twice"` ends the value at the second quote. Right: `msg=${msg//\"/\\\"}` before wrapping it.
- **Quoting everything or nothing.** Wrong: quoting nothing gives `site=Harbour Bakery`, which parses as a field named `Bakery`. Quoting every value (`pct="91"`) makes lines noisy. Quote only when the value contains a space.
- **Forgetting `shift 2`.** Symptom: the level and the message show up again as extra fields, and fail the `key=value` check. Shift them off before the loop.
- **Looping over `$*`.** Wrong: `for f in $*` splits `site=Harbour Bakery` into two words. Right: `for f in "$@"` keeps one argument as one item.
