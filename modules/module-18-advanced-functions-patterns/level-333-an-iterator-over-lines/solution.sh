#!/usr/bin/env bash
set -euo pipefail
# Customer queue: three lines per customer (name, plan, price) -> one line each.
# solution.sh QUEUE_FILE. next_line puts the next unread line in LINE, status 1 at the end.

file=$1

# TODO 1: unreadable file -> message on stderr, exit 1.
# TODO 2: load the lines into an array (mapfile -t), start cursor at 0.
# TODO 3: next_line: if cursor is past the last index return 1; otherwise LINE=the line, cursor+1.
# TODO 4: loop while next_line works (that is the name). Inside the turn, call next_line
#         twice more for plan and price; if either fails, report the incomplete record
#         (remember which line the record started on) and exit 1.
