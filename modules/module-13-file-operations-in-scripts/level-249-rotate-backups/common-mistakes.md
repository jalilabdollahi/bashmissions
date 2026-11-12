# Common Mistakes

- **Shifting newest first.** Each `mv` overwrites the next slot before it has moved on.
  - Wrong: `mv f.1 f.2; mv f.2 f.3` (`.1` overwrites `.2`, then that copy moves on to `.3`: one backup is lost)
  - Right: `rm -f f.3; mv f.2 f.3; mv f.1 f.2`
- **Not guarding missing slots.** `mv` on a missing file prints an error and, under `set -e`, ends the script.
  - Wrong: `mv "$file.2" "$file.3"` on the first run
  - Right: `if [[ -e $file.2 ]]; then mv "$file.2" "$file.3"; fi`
- **Dropping the oldest with a wildcard.** It also deletes neighbours that merely look similar.
  - Wrong: `rm -f "$file".*` (removes `.bak`, `.1`, `.2`, everything)
  - Right: `rm -f "$file.3"`
- **Using `mv` for the new backup.** The original file disappears.
  - Wrong: `mv "$file" "$file.1"`
  - Right: `cp "$file" "$file.1"`
- **Leaving names unquoted.** A file called `daily report.txt` splits into two words.
  - Wrong: `mv $file.2 $file.3`
  - Right: `mv "$file.2" "$file.3"`
