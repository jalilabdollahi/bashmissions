# Walkthrough: Small Functions

## The plan
The loop makes three separate decisions. Pull each into its own function, name it
for what it does, and let `main` read like a summary.

## Steps
1. **normalise_host**: lower-case and drop one trailing dot. It produces text, so
   it prints and the caller captures it with `$(...)`:
   ```bash
   normalise_host() {
     local host=${1,,}
     printf '%s\n' "${host%.}"
   }
   ```
2. **is_port**: a yes/no question. It prints nothing and answers with its status, so
   `if is_port "$port"` reads like English. The last command's status is the
   function's status; the first guard uses `|| return 1` so that non-numbers never
   reach the arithmetic:
   ```bash
   is_port() {
     [[ $1 =~ ^[0-9]{1,5}$ ]] || return 1
     (( 10#$1 >= 1 && 10#$1 <= 65535 ))
   }
   ```
   `10#` forces base ten, because `00080` would otherwise be read as octal.
3. **format_endpoint**: the one place that knows the output format, so a change of
   format is a one-line edit.
4. **main**: reads lines, skips blanks, rejects lines without a colon, calls the three
   helpers. Its variables are `local`.
5. End with `main "$@"`.

## Try it
```
printf 'Harbour.Example.:8080\nbad:0\n' | ./solution.sh
```
You can also source the pieces by hand in a shell and test `is_port 65536` without
running the whole script.

## Alternative
Leaving the checks inline is shorter today. The cost appears when the port rule
changes (say to allow 0 for "any") and you must find every copy of it.
