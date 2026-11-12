#!/usr/bin/env bash
# Heartbeat check: each BEAT file must be at least as new as the STAMP file.
# Output per beat: "fresh NAME", "STALE NAME" or "MISSING NAME" (NAME has no
# directory and no .beat suffix). Exit 1 if anything is not fresh.

# TODO: arguments, and the stamp must exist
# TODO: loop over the remaining arguments
# TODO: three cases per beat: missing, older than the stamp, fresh
