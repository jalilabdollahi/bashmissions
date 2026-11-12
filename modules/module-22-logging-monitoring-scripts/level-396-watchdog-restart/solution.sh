#!/usr/bin/env bash
# Watchdog: for each service, check it; if it is down, restart it ONCE and
# check again. Report ok / restarted / FAILED and exit 1 if any FAILED.

# TODO: usage check
# TODO: loop over the service names
# TODO: use the exit status of systemctl is-active as the test
# TODO: remember a failure, but keep going through the list
