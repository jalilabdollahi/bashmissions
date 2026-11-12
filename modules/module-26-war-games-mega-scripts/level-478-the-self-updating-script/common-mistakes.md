# Common Mistakes

- **Overwriting the running script.** Wrong: `cat new.sh > "$0"`. Bash reads the script while it runs, so it may execute a mixture of old and new code. Right: write `$0.new` and `mv` it over `$0`, then `exit`.
- **Comparing versions as text.** Wrong: `[[ $latest > $VERSION ]]` says `1.9.0` is newer than `1.10.0`. Right: split on dots and compare numbers, with `10#` to avoid octal surprises.
- **Trusting the version the server sends.** Wrong: using `$latest` in a URL or comparison without validation. Right: check `^[0-9]+\.[0-9]+\.[0-9]+$` first.
- **Installing before verifying.** Wrong: `mv` the download into place, then run `bash -n` on it. Right: checksum, syntax and reported version are all checked in the scratch directory first.
- **Allowing downgrades with `--force`.** Wrong: `--force` also installs an older version. Right: `--force` only reinstalls the same version; going backwards is `rollback`.
- **Losing the file mode.** Wrong: `mv "$work/new.sh" "$0"` leaves a script that is not executable. Right: `cp -p "$0" "$0.new"` first, so the permissions carry over.
