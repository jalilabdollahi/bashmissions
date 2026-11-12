#!/usr/bin/env bash
# A publish/subscribe bus in a folder: BUS/spool holds numbered messages,
# BUS/subs the subscriptions, BUS/cursor how far each subscriber has got.
#   solution.sh BUS subscribe PATTERN NAME HANDLER | unsubscribe NAME
#               | publish TOPIC MESSAGE... | dispatch | status
# Environment: MAX_TRIES (default 3) failed deliveries before a message is dead-lettered.

# TODO: usage, the bus directory must exist, name/topic/pattern/handler validation
# TODO: last_seq: the highest message number in the spool (0 when empty)
# TODO: subscribe / unsubscribe: files in subs/ and cursor/
# TODO: publish: next number, claimed with noclobber (set -C) in a subshell; retry if taken
# TODO: dispatch: per subscriber (sorted), per message above its cursor, in order:
#       skip non-matching, run the handler, move the cursor, count failures per message
# TODO: dead-letter after MAX_TRIES; a failure blocks only that subscriber's later messages
# TODO: status overview with pending and dead counts
