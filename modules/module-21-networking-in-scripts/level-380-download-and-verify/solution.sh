#!/usr/bin/env bash
# Download a release and keep it only if its checksum matches the published one.
# https://downloads.lanternfish.example/releases/NAME  and  .../NAME.cksum

# TODO: usage check; temporary files for the download and for the checksum line,
#       cleaned up by a trap on EXIT
# TODO: download both with curl -sS --fail -o ...; each has its own failure message
# TODO: cksum the temporary download and compare the first two fields (CRC and size)
#       with the published line
# TODO: equal -> mv the temporary file to NAME and print "verified: NAME"; else error, exit 1
