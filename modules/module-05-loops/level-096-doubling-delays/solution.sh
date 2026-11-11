#!/usr/bin/env bash
# Backoff schedule: BASE, then double every attempt, never above CAP.
# Print "attempt k: wait Ns" per attempt, then "total wait: Ns". No sleeping!
# TODO: check the three arguments; loop over the attempts; double; cap; add up.
echo "attempt 1: wait ${1}s"
echo "total wait: ${1}s"
