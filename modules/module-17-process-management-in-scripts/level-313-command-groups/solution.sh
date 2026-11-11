#!/usr/bin/env bash
# Turn a messy list of server names into a tidy report.txt, writing the whole
# report through ONE redirection, and leave early (with a message) if the list
# cannot be read.

# TODO: usage error (stderr, exit 2) when LIST is missing
# TODO: [[ -r "$list" ]] || { message to stderr; exit 1; }
# TODO: count the distinct, non-blank names ($(( )) around wc -l)
# TODO: { echo title; names...; echo total; } > report.txt
# TODO: print "wrote report.txt (N servers)"
