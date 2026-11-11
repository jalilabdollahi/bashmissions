# Walkthrough: Self-Documenting Help

## The plan
Make the header comment the single source of truth. A function reads the script's own
file, extracts the leading comment block and prints it; the argument handling decides
where the text goes.

## Step by step
1. **Find the file.** `$0` is how this script was started (`solution.sh` here, or a
   full path when called from elsewhere), so `"$0"` can be given to `awk` as input.
2. **Extract the block.** An awk program with three rules:
   ```awk
   NR == 1 { next }                    # skip the shebang
   /^#/    { sub(/^# ?/, ""); print; next }   # comment: strip "# " and print
           { exit }                    # first non-comment line ends the block
   ```
   The blank line after the header is not a comment, so it stops the scan before
   `set -euo pipefail`. A comment line that is only `#` becomes an empty line, which
   keeps the paragraph breaks.
3. **Wrap it** in `show_help() { ...; }`.
4. **Dispatch on the first argument** with `case "${1:-}" in`: `-h|--help` prints to
   stdout and exits 0; an empty first argument (none given) prints to stderr, with
   `show_help >&2`, and exits 2. Any other value falls through to the normal job.
   Remember `${1:-}`, because `set -u` forbids touching a missing `$1`.
5. The cleanup logic below stays unchanged.

## Try it
```
./solution.sh --help
./solution.sh; echo $?
mkdir t; touch t/a.tmp t/b.tmp; ./solution.sh t
```
Add a line to the header and run `--help` again; it shows up without any other edit.

## Alternative
`sed -n '2,/^[^#]/{/^#/s/^# \{0,1\}//p;}' "$0"` does the same in one line, but it is
harder to read and its stop condition is subtle. Awk's explicit rules are easier to
maintain.
