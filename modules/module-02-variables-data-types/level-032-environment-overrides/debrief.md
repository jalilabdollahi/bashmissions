# Debrief: Environment Overrides

## What you learned
Settings can come in layers. A script reads the environment, falls back to a default, and nests fallbacks when there is more than one possible source. The result is a script that runs with no configuration and bends when someone supplies it.

## Under the hood
`${a:-text}` expands `text` only when it needs it, and `text` may contain further expansions. Bash evaluates from the inside out, so `${APP_PORT:-${PORT:-8080}}` checks `APP_PORT` first and touches `PORT` only if necessary. The environment itself is the one you met in the last level: exported variables handed down by the parent process, which could be a shell, a service manager or a container.

Choosing lower-case names for your resolved variables is a convention: upper-case names are for the environment (settings coming in or going out to children), and lower-case for the script's own working values.

## In real work
This pattern is how twelve-factor apps and countless deploy scripts are configured: defaults in the code, overrides in the environment, no config file to edit. Operators change `PORT=...` in the unit file, not the script.

## Going further
Next: moving values between variables. A tiny puzzle that needs a helper variable.
