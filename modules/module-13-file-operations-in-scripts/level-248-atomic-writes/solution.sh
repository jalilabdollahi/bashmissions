#!/usr/bin/env bash
# Read a new config from stdin and install it as config/app.conf so that a
# reader never sees a half-written file: temp file first, mv at the end.

# TODO: make sure the config folder exists
# TODO: tmp=$(mktemp config/.app.conf.XXXXXX) and copy stdin into it
# TODO: validate (a line that is exactly port=<digits>); if bad, delete tmp,
#       complain on stderr and exit 1
# TODO: chmod 644, then mv the temp file over config/app.conf
# TODO: print "installed config/app.conf (N lines)"
