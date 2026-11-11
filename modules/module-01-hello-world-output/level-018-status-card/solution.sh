#!/usr/bin/env bash
# Status card: header block, two padded number rows, a note on stderr, and an
# exit status handed in by the collector.
# TODO: here-document for the header, printf for the rows, >&2 for the note,
#       exit "$STATUS_CODE" at the end.
echo "STATUS CARD"
