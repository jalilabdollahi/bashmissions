# Walkthrough: Reload on HUP

## The plan

A long-running program that must change its behaviour without a restart needs
three parts: a function that loads the configuration, a handler that runs it
again on demand, and a signal to trigger it. By convention that signal is
HUP ("hang up", a leftover from terminal days). `confpush` plays the
operator: it rewrites the file and sends HUP to our PID.

## Step by step

Loading is a function, because we call it twice, once at startup and once from
the handler. `sed -n 's/^greeting=//p'` strips just the first prefix and prints
the matching line, so a value like `x=y=z` survives:

```bash
load_config() {
  greeting=$(sed -n 's/^greeting=//p' "$conf" | head -n 1)
}
```

The handler reloads, raises a flag and reports:

```bash
on_hup() {
  load_config
  reloaded=1
  echo "reloaded greeting=$greeting"
}
```

Now the order. Load once and print. **Then** `trap on_hup HUP`. **Only then**
start `confpush "$$" "$conf" &`. Reversing the last two risks a HUP that arrives
while the default action is active, which terminates the script.

The main flow has nothing to do but watch the flag. Polling every 0.1 s
gives bash a chance to run the trap between commands:

```bash
for ((poll = 1; poll <= 20; poll++)); do
  sleep 0.1
  [[ $reloaded -eq 1 ]] && break
done
```

Note that the `[[ ... ]] && break` form is safe under `set -e`, because
a failing test in the *first* part of an `&&` list does not trigger it. Finish with
the success or failure message.

## The complete solution

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "usage: solution.sh CONF" >&2
  exit 2
fi
conf=$1

greeting=
reloaded=0

load_config() {
  greeting=$(sed -n 's/^greeting=//p' "$conf" | head -n 1)
}

on_hup() {
  load_config
  reloaded=1
  echo "reloaded greeting=$greeting"
}

load_config
echo "loaded greeting=$greeting"

trap on_hup HUP
confpush "$$" "$conf" &

for ((poll = 1; poll <= 20; poll++)); do
  sleep 0.1
  if [[ $reloaded -eq 1 ]]; then
    break
  fi
done

if [[ $reloaded -eq 1 ]]; then
  echo "reload handled"
else
  echo "no reload received" >&2
  exit 1
fi
```

## Try it by hand

```bash
printf 'greeting=Ahoy\n' > app.conf
printf 'greeting=Welcome aboard\n' > push.conf
./solution.sh app.conf
FAKE_NO_HUP=1 ./solution.sh app.conf; echo "exit $?"
```

## An alternative

A handler that does the whole reload is fine for small scripts. Bigger
programs only set a flag in the handler and do the reload from the main loop,
at a moment they choose, which avoids half-finished work being interrupted.
