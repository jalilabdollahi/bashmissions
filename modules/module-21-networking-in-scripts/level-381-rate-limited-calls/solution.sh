#!/usr/bin/env bash
# Fetch each customer's usage figure, but never faster than two requests a second.

# TODO: usage message and exit 2 when no IDs are given
# TODO: loop over the IDs, counting how many requests have been sent
# TODO: a failing request prints "ID: unavailable" and the loop carries on
# TODO: after every 2nd request, if IDs remain, `sleep 1`
