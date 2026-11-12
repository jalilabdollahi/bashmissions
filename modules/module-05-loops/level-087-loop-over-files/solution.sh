#!/usr/bin/env bash
# For each logs/*.log print "<name>: <line count>". Empty folder: print nothing.
# TODO: turn on nullglob, loop over the glob, count lines with wc -l.
wc -l logs/web.log
