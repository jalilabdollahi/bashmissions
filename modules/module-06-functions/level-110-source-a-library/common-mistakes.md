# Common Mistakes

- **Running instead of sourcing.** `bash fixtures/storage.sh` or
  `./fixtures/storage.sh` defines `kb_to_mb` in a child process; your script then
  fails with `kb_to_mb: command not found`. Right: `source fixtures/storage.sh`.
- **Wrong relative path.** `source storage.sh` looks in `PATH` (and sometimes the
  current folder) and fails. Right: `source fixtures/storage.sh` from the script's
  folder, or `source ./...`.
- **Sourcing after the first call.** The library must be loaded before the line that
  uses its functions.
- **Copying the function in.** It works until the library changes. Then your copy
  is the bug Gus complained about.
- **Libraries that do work.** A library with a stray `echo` or `exit` prints or ends
  the script at source time. Keep libraries to definitions.
