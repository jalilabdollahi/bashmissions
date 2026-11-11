# Walkthrough: Prompt on stderr

## The plan
Read one line like in the previous level, but let `read` show the question so a
human knows what to type. The confirmation is the only thing written to stdout.

## Building it
The prompt option takes the question as its argument:

```bash
read -p "Server to restart: " server
```

Add `-r` for raw input; the options can be bundled, so `-rp` means `-r -p`, and
the prompt text must follow immediately after the bundle that ends in `p`:

```bash
read -rp "Server to restart: " server
```

Finish with the real output:

```bash
echo "restart queued for $server"
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
read -rp "Server to restart: " server
echo "restart queued for $server"
```

## Try it by hand
```bash
./solution.sh                           # shows the prompt, you type, Enter
echo anchovy | ./solution.sh            # no prompt: stdin is not a terminal
echo anchovy | ./solution.sh 2>/dev/null
```
Because the prompt lives on stderr, `./solution.sh > out.txt` still shows it on
screen while `out.txt` gets only the confirmation.

## Alternative
`echo -n "Server: " >&2; read -r server` does the same thing by hand. It also
prompts when stdin is a pipe (which may be noise in automation), so `read -p`,
which prompts only for humans, is usually the better choice.
