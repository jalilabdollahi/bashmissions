# Walkthrough: Idempotent Scripts

## The plan
An idempotent script describes a desired *state* rather than a list of actions: "this
folder, this page and this line should exist". For each part, compare reality with the
desired state, act only on the difference, and say what happened.

## Step by step
1. **Folder.** Test, then create. (`mkdir -p` alone would not fail on an existing
   folder, but we want to report the difference, so we test anyway.) Use `-p` so a
   missing `sites/` parent is made too:
   ```bash
   if [ -d "$site" ]; then echo "dir: exists"; else mkdir -p "$site"; echo "dir: created"; fi
   ```
2. **Page.** `[ -e "$site/index.html" ]` decides. If it is missing, write it with
   `printf '<h1>%s</h1>\n' "$name"`. An existing page is never touched, even if it
   differs from the template: the customer's edits win.
3. **List entry.** `grep -qxF -- "$name" sites.list` is true only for a line that is
   exactly the name. Without `-x`, `gull` would match `gull-and-anchor`, so the site
   would never be added. Without `-F`, a name with `.` or `*` would act as a regex.
   `--` protects names that start with a dash. The file might not exist yet, hence
   `[ -f sites.list ] &&`.
4. Nothing returns a failure for "already done": every branch ends with a status 0
   command, so `set -e` never fires.

## Try it
```
./solution.sh harbour-bakery     # created, created, added
./solution.sh harbour-bakery     # exists, exists, present
cat sites.list                   # one line only
```

## Alternative
Using `mkdir -p` and `touch` and `grep -q || echo >>` as bare lines gives the same
final state in fewer lines, but you lose the report, and one hidden catch: `grep -q ||`
fails under `set -e` if the right side fails. Explicit `if` blocks read clearly.
