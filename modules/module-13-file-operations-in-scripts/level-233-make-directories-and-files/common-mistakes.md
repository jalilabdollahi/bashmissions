# Common Mistakes

- **Plain `mkdir` for a nested path.** It fails when a parent is missing.
  - Wrong: `mkdir sites/acme/logs` (when `sites` does not exist yet)
  - Right: `mkdir -p sites/acme/logs`
- **Treating "already exists" as an error.** Without `-p` the second run dies and, under `set -e`, so does the script.
  - Wrong: `mkdir "$site/backup"` on a re-run: `File exists`
  - Right: `mkdir -p "$site/backup"`
- **Using `>` to create an empty file.** It works the first time and wipes the content the second time.
  - Wrong: `> "$site/logs/access.log"` on a log that has data
  - Right: `touch "$site/logs/access.log"`
- **Forgetting quotes around a name with spaces.** `mkdir -p sites/$1/logs` splits "Gull & Anchor Pub" into several folders.
  - Wrong: `mkdir -p $site/public`
  - Right: `mkdir -p "$site/public"`
