#!/usr/bin/env bash
# Ask for a port (1-65535) until the answer is valid. Prompt and complaints go
# to stderr; the final "port=N" goes to stdout. EOF without a valid port: exit 1.
# TODO: repeat prompt + read + validation in a loop.
printf 'port> ' >&2
read -r port
echo "port=$port"
