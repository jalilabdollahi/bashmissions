# Common Mistakes

- **Diffing the raw text.** Wrong: `diff old.conf new.conf` reports re-ordered or re-commented lines as changes. Right: load both files into arrays and compare settings.
- **Confusing empty with absent.** Wrong: `[[ -z ${old[$key]} ]]` calls `motd=` "not in old", so a changed value is reported as an addition. Right: `[[ -z ${old[$key]+set} ]]` tests existence only.
- **Looping over one array only.** Wrong: iterating `"${!new[@]}"` never notices removed settings. Right: take the union with `printf '%s\n' "${!old[@]}" "${!new[@]}" | sort -u`.
- **Unordered output.** Wrong: `for key in "${!old[@]}"` prints in hash order, and the report differs between runs. Right: sort the names.
- **Always exiting 0.** Wrong: scripts cannot react to "different". Right: end with `exit 1` when anything differs, and `exit 0` for `no differences`.
