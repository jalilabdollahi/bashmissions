#!/usr/bin/env bash
# PID file doctor: is the process named in PIDFILE really NAME, and alive?
# Stale PID files (dead process, or number reused by another program) are removed.

# TODO: arguments; missing file means "stopped"
# TODO: read the pid and make sure it is a whole number
# TODO: ask ps for that pid's command name (it may print nothing)
# TODO: report running / stale and delete the file when it is stale
