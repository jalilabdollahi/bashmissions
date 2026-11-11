# Common Mistakes

- **Splitting at every colon.** Wrong: `cut -d: -f2` turns `Hostname: 127.0.0.1:5432` into `127.0.0.1`. Right: `${line#*:}` removes only up to the first colon.
- **Overwriting the new file.** Wrong: `> "$new"` silently destroys a hand-edited v2 file. Right: `[[ -e $new ]]` first, and refuse.
- **Not recognising a converted file.** Wrong: running the converter over a v2 file produces `unknown key: version=2` warnings and a doubled header. Right: check for `version=2` first and exit 0.
- **Dropping unknown settings.** Wrong: `*) ;;` quietly loses a customer's `Theme`. Right: copy it, lowercase, and warn on stderr.
- **Treating a value change as a rename.** Wrong: `Debug: on` copied as `log_level=on`, which v2 rejects. Right: map the value too (`on` to `debug`, anything else to `info`).
