#!/usr/bin/env bash
# Ticket summary.

# No colon: the fallback applies ONLY when NOTE does not exist at all.
# A note that was set to "" on purpose stays empty.
echo "note=[${NOTE-(no note on file)}]"

# With a colon: an empty CONTACT is as useless as a missing one.
echo "contact=[${CONTACT:-support@lanternfish.example}]"
