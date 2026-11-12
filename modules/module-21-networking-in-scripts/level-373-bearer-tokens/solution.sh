#!/usr/bin/env bash
# Read the account balance from the billing API, authenticating with the
# token in $LF_TOKEN. The token is a secret: it must not leak anywhere.

# TODO: refuse to run (stderr, exit 2) when LF_TOKEN is unset or empty
# TODO: make a temporary file for the body and clean it up when you are done
# TODO: call the balance endpoint with an "Authorization: Bearer ..." header
#       and capture the HTTP status code
# TODO: 200 -> "balance: <body>"; 401 -> rejected message; otherwise "unexpected HTTP <code>"
