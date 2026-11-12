# Common Mistakes

- **Using `mktemp` for a folder.** That creates a plain file, and the next `cp` into it fails or misbehaves.
  - Wrong: `stage=$(mktemp); cp page.html "$stage/"`
  - Right: `stage=$(mktemp -d)`
- **A fixed staging name.** Overlapping runs share it and mix their files.
  - Wrong: `stage=/tmp/stage; mkdir -p "$stage"`
  - Right: `stage=$(mktemp -d)`
- **Leaving the temp folder behind on errors.** The cleanup line at the bottom never runs after `exit 1`.
  - Wrong: `rm -rf "$stage"` as the last line
  - Right: `trap 'rm -rf "${stage:?}"' EXIT` right after creating it
- **Using a relative output path after `cd`.** Inside the subshell the current folder is the stage.
  - Wrong: `( cd "$stage" && tar -cf release.tar -- * )` (the tar lands in the stage and is deleted with it)
  - Right: `out="$PWD/release.tar"` before the `cd`
- **Changing directory in the main shell.** Later relative paths (like `site`) silently break.
  - Wrong: `cd "$stage"; tar ...; cp "$site/x" .`
  - Right: `( cd "$stage" && tar ... )`
