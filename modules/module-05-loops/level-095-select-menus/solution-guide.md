# Walkthrough: select Menus

## The plan
`select` is a loop that owns the whole menu dance: it prints the numbered choices, reads a line, turns the number into the matching word, and runs your body. You only describe what each outcome should do.

## Step by step
1. Open the loop with the items in menu order: `select server in anchovy barracuda cuttlefish quit; do`. The words are numbered 1 to 4 automatically.
2. After the user types, `server` holds the chosen word. If the user types something that is not a valid number, `server` is empty, while `$REPLY` always holds the raw text.
3. Branch with `case $server in`:
   - `quit)` runs `break`, which ends the loop. Without it `select` would ask again forever.
   - `"")` is the invalid case. Print `unknown choice: $REPLY`.
   - `*)` is every real server: print `restarting $server`.
4. When the input ends (end of file) `select` finishes on its own. It does so with exit status 1 though, so end the script with `exit 0` to report a clean session.
5. Optionally set `PS3` to change the prompt. The menu and the prompt are written to stderr, so only your `echo` lines reach stdout.

## Complete solution

```bash
#!/usr/bin/env bash
PS3="restart which server? "
select server in anchovy barracuda cuttlefish quit; do
  case $server in
    quit) break ;;
    "")   echo "unknown choice: $REPLY" ;;
    *)    echo "restarting $server" ;;
  esac
done
exit 0
```

## Trying it by hand
Run `bash solution.sh` in a terminal and type numbers. Then `printf '2\n4\n' | bash solution.sh` to see it work from a pipe: the menu still appears on the screen because it goes to stderr.

## An alternative
A `while true` loop with `read` and a hand-written menu gives full control over the layout but makes you do the numbering, the validation and the lookup yourself. `select` is the shortest way when a plain numbered list is enough.
