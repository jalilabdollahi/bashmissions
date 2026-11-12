# Common Mistakes

- **Checking the user with a prefix match.** `grep "^$user" passwd` finds `kit` inside `kitchen`, so you might lock the wrong person.
  - Right: compare the whole first field, `awk -F: '$1 == u'`.
- **Comparing the UID as text.** `[[ $uid < 1000 ]]` is a string comparison, so `998` is "greater" than `1000`.
  - Right: `(( uid < 1000 ))`
- **Putting the dry-run check after `usermod`.** The "would lock" message then appears after the account is already locked.
  - Right: exit from the dry-run branch before any command that changes anything.
- **Archiving with an absolute path.** `tar -czf x.tgz fixtures/home/dana` stores the whole path, and a restore recreates it.
  - Right: `-C fixtures/home dana`
- **Failing when there is no home directory.** Many accounts, especially mail-only ones, have none. Skip the archive, still lock, and say `archive: none`.
