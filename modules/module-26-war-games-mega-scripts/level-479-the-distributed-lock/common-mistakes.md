# Common Mistakes

- **Using `mkdir -p`.** `mkdir -p locks/deploy.lock` succeeds when the directory already exists, so everyone "wins". Use plain `mkdir` and read its exit status.
- **Check, then create.** `[[ -d $lock ]] || mkdir "$lock"` has a gap between the test and the creation in which another process can slip in. Let `mkdir` do the test.
- **Treating an empty lock as stale.** Right after `mkdir` the files do not exist yet. If `expires` is empty, `(( expires <= now ))` evaluates to true and you steal a live lock. Check the digits first and report busy.
- **Releasing someone else's lock.** `rm -rf "$lock"` without comparing the owner lets a late, confused process free a lock that now belongs to another. Compare, and exit with a different status.
- **Reading the real clock.** Calling `date +%s` inside the script makes the expiry rule untestable and the behaviour change from run to run. Take NOW as an argument.
