#!/usr/bin/env bash
set -euo pipefail

# -s: silent, the terminal does not echo the typed characters.
# -r: raw, so backslashes in a password are kept.
# -p: the prompt (shown on a terminal only).
read -rsp "Admin password: " password

# Silent mode also swallows the user's Enter key, so the screen cursor would be
# stuck at the end of the prompt. A newline on stderr tidies it up.
echo >&2

# Report only the length. Never print the secret itself.
echo "password stored (${#password} characters)"
