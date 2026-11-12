#!/usr/bin/env bash
# Retention policy for a folder of nightly archives: the newest 7 stay, older
# ones stay only if they are Sunday backups, everything else goes. -n = dry run.

# TODO: handle the optional -n flag, then require DIR (usage, exit 2)
# TODO: refuse a DIR that does not exist (exit 1)
# TODO: collect the *.tar.gz files into an array (an empty folder must not break)
# TODO: the index of each file tells you if it is among the newest 7
# TODO: print keep/delete (or "would delete") lines, then the kept/deleted summary
