#!/usr/bin/env bash
# Pack SITE/*.html (minus draft-*.html) into ./release.tar via a private
# staging folder. The staging folder must vanish when the script ends.

# TODO: usage and "no such folder" checks
# TODO: stage=$(mktemp -d), plus a trap that removes it
# TODO: copy the wanted pages in and write MANIFEST there
# TODO: run tar from INSIDE the staging folder; the archive goes to the current folder
# TODO: print "packed N pages into release.tar" and the sorted archive listing
