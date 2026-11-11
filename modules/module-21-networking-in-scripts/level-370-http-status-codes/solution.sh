#!/usr/bin/env bash
# Check a list of URLs and print the HTTP status code of each one,
# then count how many of them are a problem (400 and up, or no connection).

# TODO: usage message on stderr and exit 2 when there are no arguments
# TODO: for every URL, run curl quietly, throw the body away, print only the code
# TODO: curl exits non-zero when it cannot connect; do not let that stop the loop
# TODO: print "<code> <url>" per URL, count the problems, print "problems: N", exit 1 if N > 0
