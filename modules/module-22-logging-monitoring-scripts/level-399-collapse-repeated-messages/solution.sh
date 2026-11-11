#!/usr/bin/env bash
# Fold runs of repeated messages: stdin lines are "HH:MM:SS message".
# Print the first line of a run, then "last message repeated R times".

# TODO: loop over stdin; split off the timestamp to get the message part
# TODO: same message as the previous line? count it, print nothing yet
# TODO: different message? first flush the pending count, then print the line
# TODO: after the loop, flush once more (the final run is still pending)
