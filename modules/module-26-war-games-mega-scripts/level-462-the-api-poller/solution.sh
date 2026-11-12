#!/usr/bin/env bash
# API poller run from cron: read each service's status, confirm changes before
# alerting, post a webhook, and queue alerts the webhook could not take.
#   solution.sh --webhook URL [--confirm N] ENDPOINTS

# TODO: parse --webhook and --confirm, validate, read ENDPOINTS (exit 2 on mistakes)
# TODO: post(): curl -X POST with a JSON body to the webhook
# TODO: notify(): post or append to state/outbox, remember "sent" / "queued"
# TODO: flush_outbox(): retry queued bodies at the start of every run
# TODO: fetch_status(): curl + sed -> ok / degraded / down / unreachable / invalid
# TODO: per endpoint: load "CONFIRMED CANDIDATE COUNT", apply the confirmation rules,
#       print the status line, save the state
# TODO: exit 1 if any confirmed status is not ok
