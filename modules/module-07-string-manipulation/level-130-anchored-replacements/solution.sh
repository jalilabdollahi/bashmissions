#!/usr/bin/env bash
# Migration list rewriter. Input: one path per line on stdin.
# Leading "/var/log/legacy/" -> "/var/log/lanternfish/" ; trailing ".log" -> ".log.gz"
# Anything in the MIDDLE of a path must stay as it is.
# TODO: loop over the lines, apply the start-anchored and the end-anchored replacement.
# TODO: print each resulting path.
