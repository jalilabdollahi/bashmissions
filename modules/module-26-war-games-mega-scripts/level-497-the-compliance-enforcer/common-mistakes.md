# Common Mistakes

- **Declaring victory without re-checking.** Printing `FIXED` right after `chmod` hides fixes that did not work (wrong path, read-only mount). Call `evaluate` again and report `STILL FAILING` when it fails.
- **`mv "$tmp" "$file"` to rewrite a file.** The temp file is mode 0600, so `/etc/passwd` becomes unreadable for everyone else. Overwrite in place with `cat "$tmp" > "$file"`, or restore the mode afterwards.
- **Comparing `600` with `0600` as strings.** They are the same mode and different strings. Normalise to the last three digits and one fixed width.
- **Backing up with plain `cp`.** The backup gets today's timestamp and your default mode. Use `cp -p`, and do it before the change, once per file.
- **Letting `set -e` kill the run on a failed `grep -c`.** `grep` exits 1 when nothing matches. Write `count=$(grep -cE "$re" "$f" || true)`.
- **Forgetting the dry run in the exit status.** A dry run that finds work to do has *not* made the system compliant, so it should not exit 0.
- **Waivers that never expire.** Compare the waiver's `until` with the current time every run, and mention expired ones so somebody renews or removes them.
- **Rules that can escape the root.** A `..` in a path lets a rule change files outside the tree. Reject it while parsing.
