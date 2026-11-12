# Common Mistakes

- **Creating the folder with the default mode.** Anyone on the box can read process lists and connection tables until you `chmod`.
  - Right: `mkdir -m 700 "$dir"`
- **Letting one failing command abort the snapshot.** With `set -e`, a missing `ss` ends the script before `ps` output would have been saved.
  - Right: `ssh ... > "$file" 2>&1 || rc=$?` and record `ERROR: exit N`.
- **Saving only stdout.** The error message of a failing command is evidence too.
  - Right: `> "$file" 2>&1`
- **Computing the manifest before the last file is written.** The checksum of `meta.txt` is then wrong, or missing from the list.
  - Right: write MANIFEST as the final file, from inside the folder.
- **Overwriting an existing incident folder.** A second run with the same stamp wipes the first responder's notes.
  - Right: check `[[ -e $dir ]]` first and refuse.
