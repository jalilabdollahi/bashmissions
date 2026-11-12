#!/usr/bin/env bash
# Audit sshd_config the way sshd reads it: first value wins, Match blocks are
# not global, case does not matter, unset keys use the built-in default.

# TODO: usage and readability checks
# TODO: read the file once, normalising "Key value" / "Key=value" lines
# TODO: remember only the FIRST value per keyword; stop at the first Match line
# TODO: for the five audited keywords, fall back to the documented default
# TODO: print PASS/FAIL lines with the "(default ...)" / "(want ...)" annotations
# TODO: summary line and exit status
