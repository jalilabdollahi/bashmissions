#!/usr/bin/env bash
set -euo pipefail
# Event bus. stdin: "on EVENT HANDLER" registers, "emit EVENT WORD..." calls the handlers.

h_log()  { echo "log: $*"; }
h_mail() { echo "mail to ops: $*"; }
h_page() { echo "paging on-call: $*"; }

# TODO 1: declare -A handlers (event name -> space-separated function names).
# TODO 2: on(): check HANDLER is a function (declare -F), then append it to that event's entry.
# TODO 3: emit(): loop over the entry for the event, calling each handler with the remaining words.
#         No entry -> "emit: nobody listens to 'EVENT'".
# TODO 4: main loop: read each line into words (read -ra), skip blanks, send to on/emit,
#         report unknown words, remember problems and exit 1 at the end if there were any.
