#!/usr/bin/env bash
# Header: a here-document keeps the text readable and expands $SERVER.
cat <<EOF
=== STATUS CARD: $SERVER ===
Region: harbour-east
EOF

# Numbers: fixed-width columns so the card lines up for any value.
printf '%-12s %5d\n' "uptime days" "$UPTIME"
printf '%-12s %5d\n' "open alerts" "$ALERTS"

# Log note goes to stderr so it never mixes with the card on stdout.
echo "$(basename "$0"): card printed for $SERVER" >&2

# Tell the caller how the server is doing.
exit "$STATUS_CODE"
