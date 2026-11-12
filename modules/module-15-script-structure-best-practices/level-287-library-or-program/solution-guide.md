# Walkthrough: Library or Program?

## The plan
The functions are already right. The problem is what the file does when it is read:
it runs `main` (and prints usage, then exits Ollie's shell) and it switches on strict
mode in whatever shell sourced it. We make both of those conditional.

## The tell-tale
- Executed as `bash solution.sh`, bash sets `$0` to `solution.sh`, and
  `${BASH_SOURCE[0]}` is also `solution.sh`.
- Sourced from `use-lib.sh`, `$0` is `use-lib.sh` (the running script) while
  `${BASH_SOURCE[0]}` is `.../solution.sh`.
So `[[ ${BASH_SOURCE[0]} == "$0" ]]` is true only when the file is the program.

## Steps
1. Remove `set -euo pipefail` from the top. A sourced file's `set` affects the sourcing
   shell, so a library must not toggle options globally.
2. Replace the last line with a guard that also holds the strict mode:
   ```bash
   if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
     set -euo pipefail
     main "$@"
   fi
   ```
3. Keep `local` variables in the functions, since a library shares the caller's
   namespace.

## Try both sides
```
./solution.sh "Harbour Bakery" "C++ & Go"   # program
bash fixtures/use-lib.sh                      # library: sourced ok, slug: north-pier-dental
```

## Alternative
Python's `if __name__ == "__main__":` is the same idea. In bash you can also use
`return 0 2>/dev/null || main "$@"`, which relies on `return` failing outside a
sourced file; the BASH_SOURCE test says what it means.
