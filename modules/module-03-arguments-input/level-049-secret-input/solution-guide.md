# Walkthrough: Secret Input

## The plan
Three small jobs: read without echo, tidy the terminal line, and report something
about the secret that is not the secret.

## Building it
`-s` is the silent flag. Together with the options from earlier levels it becomes
`-rsp`: raw, silent, prompt.

```bash
read -rsp "Admin password: " password
```

When echo is off, the Enter key the user presses is not echoed either, so the
next output would appear on the same line as the prompt. A bare `echo` to stderr
adds the missing newline without touching stdout:

```bash
echo >&2
```

To confirm that something was stored, report its length. `${#password}` is the
number of characters in `$password`:

```bash
echo "password stored (${#password} characters)"
```

## Complete solution
```bash
#!/usr/bin/env bash
set -euo pipefail
read -rsp "Admin password: " password
echo >&2
echo "password stored (${#password} characters)"
```

## Try it by hand
```bash
./solution.sh                 # type something: nothing appears
echo hunter2 | ./solution.sh  # piped input also works
```

## Alternative
`stty -echo; read -r pw; stty echo` does the same job, but if the script dies
between the two stty calls the terminal stays silent until you run `reset`.
`read -s` restores the terminal for you.
