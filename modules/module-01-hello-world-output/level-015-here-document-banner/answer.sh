#!/usr/bin/env bash
# Everything between <<EOF and the closing EOF is fed to cat as it is,
# including blank lines and indentation. $VARIABLES are expanded because the
# EOF marker is not quoted.
cat <<EOF
Dear $CUSTOMER,

We will be doing maintenance on your server during:
    $WINDOW
Your sites may be unavailable for a few minutes.

-- Lanternfish Hosting
EOF
