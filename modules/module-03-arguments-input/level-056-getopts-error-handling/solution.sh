#!/usr/bin/env bash
# Port-probe front end for the support desk: -h HOST (required), -p PORT (443), -q.
# Mistakes get Lanternfish-style messages on stderr and exit status 2, instead of
# getopts' own default wording.
# TODO: defaults, a getopts loop in silent mode with branches for v, \? and :,
#       the "-h required" check, then the normal or quiet output line.
