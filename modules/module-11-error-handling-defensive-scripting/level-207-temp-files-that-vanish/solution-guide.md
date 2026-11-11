# Walkthrough: Temp Files That Vanish

## The plan
Replace the fixed `/tmp/clean-list.txt` with a file whose name Bash gets from
`mktemp`, and make sure the file is deleted by an EXIT trap so that every road
out of the script passes through the cleanup.

## Step by step
1. `set -e` first, so an error ends the script (and triggers the trap).

2. Ask for a private scratch file and keep its path:

   ```bash
   tmp=$(mktemp "${TMPDIR:-/tmp}/list.XXXXXX")
   ```

   `mktemp` creates the file, replaces the X characters with random ones, and
   prints the path. Spelling out `${TMPDIR:-/tmp}` keeps it in the right
   folder on macOS and Linux alike. Two runs at the same time get two different files.

3. Register the funeral right away:

   ```bash
   trap 'rm -f "$tmp"' EXIT
   ```

   Single quotes delay reading `$tmp` until the trap fires. Registering before
   any other step means even a failure on the very next line cannot leave the
   file behind.

4. Do the work through the variable:

   ```bash
   sort -u "$1" > "$tmp"
   lanternupload "$tmp"
   echo "sent clean copy of $1"
   ```

## Three ways out, one cleanup
- success: last line runs, the shell exits, the trap fires;
- upload fails with status 7: `set -e` exits with 7, the trap fires;
- missing list: `sort` fails with 2, `set -e` exits, the trap fires.

## Try it by hand
```bash
printf 'b\na\nb\n' > list.txt
./solution.sh list.txt; ls "${TMPDIR:-/tmp}" | head
FAKE_UPLOAD_FAIL=1 ./solution.sh list.txt; echo "exit=$?"
```

## Alternative
`mktemp -d` makes a scratch *directory* and `rm -rf "$dir"` cleans it, which is
handy when you need several files. For one file, the plain form is enough.
