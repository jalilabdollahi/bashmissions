# Common Mistakes

- **`mv -f .current.tmp current` without `-T` / `-h`.** When `current` points at a directory, the new link lands inside `releases/blue/` and `current` never changes. Check with `ls -l` and `ls releases/blue`.
- **`rm current; ln -s ...`.** For a moment there is no `current`; a request in that window gets a 404. Build the new link under another name and rename it.
- **Forgetting `-n` on `ln -sfn`.** If the temp name is a left-over link to a directory, plain `ln -sf` creates the new link inside the target directory instead of replacing it.
- **Absolute link targets.** `ln -s /srv/site/releases/green current` breaks when the folder is moved or mounted elsewhere. Use the relative `releases/green`.
- **Flipping before the smoke test.** The point of the idle slot is to find problems before users do. Test first, switch second, and make a failed test change nothing.
- **Leaving the temp link behind on failure.** Without a `trap ... EXIT`, an interrupted run leaves `.current.tmp` for the next run to trip over.
