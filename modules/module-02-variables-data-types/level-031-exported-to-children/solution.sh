#!/usr/bin/env bash
# Run Theo's reporting tool for one site. Decide which of the script's
# variables the tool is allowed to see, and which stay private.
# SITE comes from the scheduler; the tool is fixtures/child.sh.

# TODO: REGION = SITE, visible to child programs
# TODO: SCRATCH = /srv/scratch/<SITE>, private to this script
# TODO: run the reporting tool with bash
# TODO: print "parent sees: REGION=[...] SCRATCH=[...]"
