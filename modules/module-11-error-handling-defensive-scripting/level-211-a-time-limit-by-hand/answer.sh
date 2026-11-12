#!/usr/bin/env bash
limit=$1

lanternscan &          # runs in the background; the script carries on at once
pid=$!                 # PID of that background job

sleep "$limit"         # the time we are willing to give it

if kill -0 "$pid" 2>/dev/null; then
  # kill -0 sends no signal, it only asks "does this process still exist?"
  kill "$pid"
  wait "$pid" 2>/dev/null     # reap it so no zombie or stray output remains
  echo "scan timed out after $limit seconds" >&2
  exit 124
fi

wait "$pid"
status=$?
if (( status != 0 )); then
  echo "scan failed with status $status" >&2
  exit "$status"
fi
