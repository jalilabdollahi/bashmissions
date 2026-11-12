# Walkthrough: Dry-Run Mode

## The plan
A dry run needs one decision point. We collect every command that changes the
world behind a helper, `run`. The helper receives the full command as arguments
and either executes it or prints it.

## Step by step
1. The starter already parses the flag: `--dry-run` sets `dry_run=1` and is
   removed with `shift`, so `$1` is the site afterwards. It also checks that
   exactly one argument is left.

2. Write the helper:

   ```bash
   run() {
     if (( dry_run )); then
       printf 'would run:'
       printf ' %q' "$@"
       printf '\n'
     else
       "$@"
     fi
   }
   ```

   `"$@"` keeps each argument a separate word, so `run touch "a b"` really
   passes one file name. `printf ' %q' "$@"` applies the format once per
   argument, giving a space before each word, and `%q` backslash-escapes
   anything that would otherwise be split, so `Tidewater Books` prints as
   `Tidewater\ Books`.

3. Prefix the three commands with `run`. Nothing else about them changes:

   ```bash
   run mkdir -p "sites/$site/logs"
   run touch "sites/$site/logs/access.log"
   run chmod 750 "sites/$site"
   ```

4. End with a message that depends on the mode, so nobody mistakes a rehearsal
   for the real thing.

## Complete solution
See the helper above. The full script is: the flag parsing from the starter, `run`,
the three `run` lines, and

```bash
if (( dry_run )); then
  echo "dry run only, nothing changed"
else
  echo "provisioned $site"
fi
```

## Try it by hand
```bash
./solution.sh --dry-run eel; ls sites 2>&1
./solution.sh eel; ls sites/eel/logs
```

## Alternative
Put `if (( dry_run )); then echo ...; else ...; fi` around each command. It
works, but a forgotten `if` means a dry run that really deletes something.
Routing every change through `run` makes that mistake visible: a bare command
without `run` stands out in review.
