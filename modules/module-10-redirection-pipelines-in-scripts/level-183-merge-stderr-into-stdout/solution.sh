#!/usr/bin/env bash
# Run sync-tool on $1 with stdout AND stderr going into sync.log
# (use "> file" first, then copy stderr onto stdout).
# Then print "sync exit status: N" and exit 0 yourself.

target=$1

sync-tool "$target"
# TODO: redirect both streams into sync.log, in the right order
# TODO: remember the tool's exit status and print it
