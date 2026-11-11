#!/usr/bin/env bash
# Health-check entry point that accepts its hostname two ways:
#   ./solution.sh anchovy          (argument)
#   echo anchovy | ./solution.sh   (standard input)
# TODO: take $1 if present, otherwise read a line; refuse if still empty.
