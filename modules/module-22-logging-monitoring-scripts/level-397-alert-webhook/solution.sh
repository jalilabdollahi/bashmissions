#!/usr/bin/env bash
# Post an alert to a chat webhook (WEBHOOK_URL) as a one-line JSON document and
# report whether the server accepted it (HTTP 2xx).

# TODO: check the arguments, the severity word and that WEBHOOK_URL is set
# TODO: escape \ and " in the message, then build the JSON text
# TODO: POST it with curl and keep only the HTTP status code
# TODO: 2xx -> "alert sent", anything else -> "alert failed" on stderr, exit 1
