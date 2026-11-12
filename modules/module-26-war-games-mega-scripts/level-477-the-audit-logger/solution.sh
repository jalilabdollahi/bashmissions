#!/usr/bin/env bash
# Audit logger: a hash chain across rotated segments, an external anchor, a writer
# lock, and a search that will not answer from a tampered log.
#   solution.sh append ACTOR ACTION DETAIL... | verify [--anchor] | checkpoint
#   solution.sh rotate [--max N] | search [--actor A] [--action X] [--from SEQ] [--to SEQ] [--force]

# TODO: usage and validation of ACTOR / ACTION / DETAIL (exit 2)
# TODO: checksum PREV SEQ TS ACTOR ACTION DETAIL: first number of cksum over the exact text
# TODO: walk: read seg-*.log then current.log, IFS='|' read the six fields (the last keeps any '|'),
#       check format, SEQ and SUM; report "FILE line N (reason)"; remember the last SEQ and SUM
# TODO: lock: mkdir audit/lock (exit 4 when it exists) and a trap that removes it
# TODO: append, verify [--anchor], checkpoint (anchor via temp file + mv), rotate [--max N], search
