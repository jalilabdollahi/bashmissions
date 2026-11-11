#!/usr/bin/env bash
# Limit parallel renders with a semaphore made of a named pipe: SLOTS tokens
# go in, every job takes one before it starts and returns it when it ends.

# TODO: usage error (stderr, exit 2) without arguments; slots=$1; shift
# TODO: mkfifo slots.fifo; exec 3<> slots.fifo; rm slots.fifo
# TODO: put $slots tokens in (echo >&3), empty failed.log
# TODO: per scene: read -r -u 3, then { render ...; echo >&3; } &
# TODO: wait; print "rendered N, failed F"; exit 1 if F > 0
