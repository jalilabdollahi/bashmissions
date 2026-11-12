#!/usr/bin/env bash
# Status wall: three coloured verdicts for the service named in $SERVICE.
# TODO: for each line, start the colour, print the word, reset the colour,
#       then the rest of the sentence. One printf per line.
printf 'OK %s responds in time\n' "$SERVICE"
