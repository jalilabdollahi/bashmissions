#!/usr/bin/env bash
# Disk check: $1 is the usage in percent. Turn it into a level.
# FULL at 100, CRITICAL from 90, WARNING from 70, otherwise OK.

# TODO: keep the number in a variable
# TODO: check the most severe level first (a ladder, top to bottom)
# TODO: use the numeric operators -eq / -ge, not ==
