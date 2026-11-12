#!/usr/bin/env bash
# Sort a file name from the spool folder into an action. Rules are tried in order:
#   tmp-*  /  *.log  /  crash-?.dump  /  anything else.
# $1 is the file name.

# TODO: name the argument
# TODO: if / elif ladder where each test is  [[ $name == PATTERN ]]  (pattern NOT quoted)
# TODO: print "<name> -> <action>"
