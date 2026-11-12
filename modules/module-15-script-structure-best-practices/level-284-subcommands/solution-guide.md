# Walkthrough: Subcommands

## The plan
Three small verbs plus a switchboard. The switchboard knows only the verb names; each
verb function knows only its own arguments.

## Steps
1. **Dispatcher first.** The start of `main` checks that a verb exists, reads it, and
   removes it with `shift`; after that `"$@"` is exactly what the verb needs:
   ```bash
   verb=${1:-}
   [ "$#" -ge 1 ] || usage
   shift
   case "$verb" in
     add) cmd_add "$@" ;;
     ...
     *) echo "solution.sh: unknown command: $verb" >&2; exit 2 ;;
   esac
   ```
2. **cmd_add** needs at least one word. `"$*"` joins the words with one space each,
   so `add rotate the logs` stores `rotate the logs`:
   ```bash
   printf '%s\n' "$text" >> "$NOTES"
   ```
3. **cmd_remove** validates before touching the file. The regex `^[1-9][0-9]*$`
   accepts positive whole numbers only; after that compare against the line count
   (`$(( $(wc -l < file) ))` strips macOS padding). To delete line `n`, write the
   result to a temp file and `mv` it over the original: `sed "${n}d" file > file.tmp`.
4. **cmd_list** keeps the awk numbering already in the starter.
5. End with `main "$@"`.

## Try it
```
./solution.sh add buy ice
./solution.sh add renew the cert
./solution.sh list
./solution.sh remove 1
./solution.sh nonsense; echo $?
```

## Alternative
A chain of `if [ "$1" = add ]` tests works but grows ugly; `case` also lets you give a
verb aliases such as `ls|list)`. Another route is to look up `cmd_$verb` dynamically
with `declare -F`, which needs more care with user input.
