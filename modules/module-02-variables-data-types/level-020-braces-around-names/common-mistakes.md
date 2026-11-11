# Common Mistakes

- **Underscore after the name.**
  Wrong: `"$NODE_backup.tar.gz"` becomes `.tar.gz`, because `NODE_backup` is read as the name.
  Right: `"${NODE}_backup.tar.gz"`.
- **Digit after the name.**
  Wrong: `"$NODE2"` looks up a variable called `NODE2`.
  Right: `"${NODE}2"`.
- **Braces in the wrong place.**
  Wrong: `"{$NODE}_backup"` prints literal braces around the value.
  Right: the dollar goes first, `"${NODE}_backup"`.
- **Expecting an error.** Bash does not complain about unknown variables; it substitutes nothing. When a result is missing a chunk, suspect a name that ran on too long.
