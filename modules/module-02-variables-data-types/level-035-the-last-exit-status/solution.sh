#!/usr/bin/env bash
# Is the server in service, retired, or neither? Ask grep twice, keep both
# answers (exit statuses), report them, and exit like the first check did.
# HOST comes from the inventory tool.

# TODO: grep -q -x -F for HOST in fixtures/active.txt, save $? at once
# TODO: the same for fixtures/retired.txt
# TODO: print "active=N" and "retired=N"
# TODO: exit with the first status
