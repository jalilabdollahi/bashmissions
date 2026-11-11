#!/usr/bin/env bash
# Ask replica-status until it succeeds; report every failed check by number.
# TODO: keep a check counter and loop with until. Ready means exit status 0.
if replica-status; then
  echo "replica ready after 1 check(s)"
fi
