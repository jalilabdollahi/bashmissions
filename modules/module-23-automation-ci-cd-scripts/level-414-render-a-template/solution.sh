#!/usr/bin/env bash
set -euo pipefail
# Fill the ${NAME} and ${NAME:-fallback} placeholders of template $1 from the
# environment. Values are data: never evaluate or re-scan them.

# TODO 1: unreadable template -> stderr message, exit 2.
# TODO 2: for each line, repeatedly find the first "${" and copy everything
#         before it unchanged.
# TODO 3: right after it, a regex decides: valid placeholder (name, optional
#         :-fallback, closing brace) or just literal text.
# TODO 4: use [[ -v name ]] and ${!name} for the lookup; collect unknown names
#         once each instead of stopping.
# TODO 5: print the result only if nothing was missing; otherwise stderr + exit 1.
