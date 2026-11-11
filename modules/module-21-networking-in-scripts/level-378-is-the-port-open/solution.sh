#!/usr/bin/env bash
# Knock on TCP ports and report which ones answer.
# ./solution.sh mail.lanternfish.example 25 587 993

# TODO: need a HOST and at least one PORT, else usage on stderr and exit 2
# TODO: shift the host off, then loop over the remaining ports
# TODO: run nc in scan mode with a 2 second timeout inside an "if" so a failure
#       does not stop the script
# TODO: print "HOST:PORT open" or "HOST:PORT closed"; exit 1 if any port was closed
