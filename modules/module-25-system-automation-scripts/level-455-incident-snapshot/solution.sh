#!/usr/bin/env bash
# First response snapshot: gather uptime, df, ps and ss output from a host into
# a private evidence folder, add a meta file, and seal it with a cksum manifest.

# TODO: usage; refuse to reuse an existing incident-STAMP-HOST folder
# TODO: create the folder so that only you can enter it (mode 700)
# TODO: run the four commands over ssh in order; save stdout+stderr per file
# TODO: non-zero exit -> append "ERROR: exit N" and count it; 255 -> clean up, exit 1
# TODO: meta.txt, then MANIFEST from inside the folder (sorted, bare names)
# TODO: the three summary lines
