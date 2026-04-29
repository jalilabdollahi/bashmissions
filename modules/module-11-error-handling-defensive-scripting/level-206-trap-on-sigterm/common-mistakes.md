# Common Mistakes

- Checking `$?` after another command has already changed it.
- Letting `set -e` abort the whole script when the level expects you to handle the failure.
- Printing debug text that is not part of the expected output.
